#!/bin/bash
set -e

echo "========== Employee App EC2 Bootstrap Started =========="

# -------------------------------
# System update
# -------------------------------
yum update -y

# -------------------------------
# Install required packages
# -------------------------------
yum install -y docker git wget

# -------------------------------
# Docker setup
# -------------------------------
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# -------------------------------
# Ensure SSM Agent is running
# -------------------------------
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# -------------------------------
# Install Node Exporter
# -------------------------------
useradd --no-create-home --shell /bin/false node_exporter || true

cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
tar -xzf node_exporter-1.8.1.linux-amd64.tar.gz
cp node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/
chown node_exporter:node_exporter /usr/local/bin/node_exporter

cat <<EOF >/etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

# -------------------------------
# App directory
# -------------------------------
mkdir -p /opt/app
chown -R ec2-user:ec2-user /opt/app

# -------------------------------
# Create deploy.sh (DO NOT RUN)
# -------------------------------
cat << 'EOF' > /opt/app/deploy.sh
#!/bin/bash
set -e

echo "========== Deployment Started =========="

# -------------------------------
# GHCR login (only for private images)
# -------------------------------
if [[ "$BACKEND_IMAGE" == ghcr.io/* ]]; then
  echo "$GHCR_TOKEN" | docker login ghcr.io -u "$GHCR_USER" --password-stdin
fi

docker stop employee-backend || true
docker stop employee-frontend || true
docker rm employee-backend || true
docker rm employee-frontend || true

docker pull "$BACKEND_IMAGE"
docker pull "$FRONTEND_IMAGE"

docker network create employee-net || true

docker run -d \
  --name employee-backend \
  --network employee-net \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://$DB_HOST:3306/employee_availability?createDatabaseIfNotExist=true \
  -e SPRING_DATASOURCE_USERNAME=$DB_USER \
  -e SPRING_DATASOURCE_PASSWORD=$DB_PASS \
  "$BACKEND_IMAGE"

docker run -d \
  --name employee-frontend \
  --network employee-net \
  -p 80:80 \
  "$FRONTEND_IMAGE"

echo "========== Deployment Completed =========="
EOF

chmod +x /opt/app/deploy.sh

echo "EC2 ready. deploy.sh installed. Waiting for CI/CD trigger." \
  > /opt/app/README.txt

echo "========== Employee App EC2 Bootstrap Completed =========="
