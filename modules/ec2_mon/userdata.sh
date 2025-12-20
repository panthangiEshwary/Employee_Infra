#!/bin/bash

LOG_FILE=/var/log/monitoring-bootstrap.log
exec > >(tee -a $LOG_FILE) 2>&1

echo "===== Monitoring bootstrap started ====="

# -------------------------
# Install Docker
# -------------------------
yum update -y
yum install -y docker curl || amazon-linux-extras install docker -y
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
# Create directories
# -------------------------
mkdir -p /opt/monitoring/grafana/{dashboards,provisioning/datasources,provisioning/dashboards}
cd /opt/monitoring

# -------------------------
# Write Prometheus / Alert configs
# -------------------------
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

# -------------------------
# Grafana datasource provisioning
# -------------------------
cat <<EOF > grafana/provisioning/datasources/prometheus.yml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
EOF

# -------------------------
# Grafana dashboard provisioning
# -------------------------
cat <<EOF > grafana/provisioning/dashboards/dashboards.yml
apiVersion: 1
providers:
  - name: Employee Dashboards
    folder: Employee
    type: file
    options:
      path: /var/lib/grafana/dashboards
EOF

# -------------------------
# Download dashboards
# -------------------------
curl -L https://grafana.com/api/dashboards/1860/revisions/37/download \
  -o grafana/dashboards/node-exporter.json

curl -L https://grafana.com/api/dashboards/4701/revisions/9/download \
  -o grafana/dashboards/jvm.json

curl -L https://grafana.com/api/dashboards/6756/revisions/1/download \
  -o grafana/dashboards/spring-boot.json

# -------------------------
# Wait for Docker & start stack
# -------------------------
echo "Waiting for Docker..."
until docker info >/dev/null 2>&1; do
  sleep 5
done

/usr/local/bin/docker-compose up -d

echo "===== Monitoring bootstrap completed ====="
