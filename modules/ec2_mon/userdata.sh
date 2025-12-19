#!/bin/bash

LOG_FILE=/var/log/monitoring-bootstrap.log
exec > >(tee -a $LOG_FILE) 2>&1

echo "===== Monitoring bootstrap started ====="

# -------------------------
# Install Docker
# -------------------------
yum update -y
yum install -y docker || amazon-linux-extras install docker -y
systemctl enable docker
systemctl start docker

# -------------------------
# Install Docker Compose
# -------------------------
mkdir -p /usr/local/bin
curl -L https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# -------------------------
# Write config files
# -------------------------
mkdir -p /opt/monitoring
cd /opt/monitoring

cat <<EOF > prometheus.yml
${prometheus_config}
EOF

cat <<EOF > alert-rules.yml
${alert_rules_config}
EOF

cat <<EOF > alertmanager.yml
${alertmanager_config}
EOF

cat <<EOF > docker-compose.yml
${docker_compose}
EOF

echo "Waiting for Docker..."
until docker info >/dev/null 2>&1; do
  sleep 5
done

/usr/local/bin/docker-compose up -d

echo "===== Monitoring bootstrap completed ====="
