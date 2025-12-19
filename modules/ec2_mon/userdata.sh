#!/bin/bash

LOG_FILE=/var/log/monitoring-bootstrap.log
exec > >(tee -a $LOG_FILE) 2>&1

echo "===== Monitoring bootstrap started ====="

# -------------------------
# Install Docker (safe way)
# -------------------------
echo "Installing Docker..."
if ! command -v docker &>/dev/null; then
  yum update -y
  yum install -y docker || amazon-linux-extras install docker -y
fi

systemctl enable docker
systemctl start docker

docker --version

# -------------------------
# Install Docker Compose
# -------------------------
echo "Installing Docker Compose..."
if ! command -v docker-compose &>/dev/null; then
  mkdir -p /usr/local/bin
  curl -L https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 \
    -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi

docker-compose version

# -------------------------
# Create monitoring directory
# -------------------------
mkdir -p /opt/monitoring
cd /opt/monitoring

# -------------------------
# Write configuration files
# -------------------------
echo "Writing Prometheus config..."
cat <<EOF > prometheus.yml
${templatefile("${path.module}/prometheus.yml.tpl", {
  app_private_ip = var.app_private_ip
})}
EOF

echo "Writing Alert rules..."
cat <<EOF > alert-rules.yml
${templatefile("${path.module}/alert-rules.yml.tpl", {})}
EOF

echo "Writing Alertmanager config..."
cat <<EOF > alertmanager.yml
${templatefile("${path.module}/alertmanager.yml.tpl", {})}
EOF

echo "Writing Docker Compose file..."
cat <<EOF > docker-compose.yml
${templatefile("${path.module}/docker-compose.yml.tpl", {})}
EOF

# -------------------------
# Start monitoring stack
# -------------------------
echo "Starting monitoring stack..."
/usr/local/bin/docker-compose up -d

echo "===== Monitoring bootstrap completed ====="
