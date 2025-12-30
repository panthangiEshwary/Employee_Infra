#!/bin/bash
set -euxo pipefail

LOG_FILE=/var/log/monitoring-bootstrap.log
exec > >(tee -a $LOG_FILE) 2>&1

echo "===== Monitoring bootstrap started ====="

####################################
# System update & dependencies
####################################
dnf update -y
dnf remove -y curl-minimal || true
dnf install -y curl --allowerasing

####################################
# Install Docker
####################################
dnf install -y docker
systemctl enable docker
systemctl start docker

####################################
# Install Docker Compose v2
####################################
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
docker compose version

####################################
# Prepare monitoring directories
####################################
mkdir -p /opt/monitoring/grafana/{dashboards,provisioning/datasources,provisioning/dashboards}
cd /opt/monitoring

####################################
# Write config files from Terraform
####################################
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

####################################
# Validate docker-compose.yml
####################################
if [ ! -s docker-compose.yml ]; then
  echo "ERROR: docker-compose.yml is empty"
  exit 1
fi

####################################
# Grafana datasource provisioning
####################################
cat <<EOF > grafana/provisioning/datasources/prometheus.yml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
EOF

####################################
# Grafana dashboard provider
####################################
cat <<EOF > grafana/provisioning/dashboards/dashboards.yml
apiVersion: 1
providers:
  - name: Employee Dashboards
    folder: Employee
    type: file
    disableDeletion: false
    editable: true
    options:
      path: /var/lib/grafana/dashboards
EOF

####################################
# Download REQUIRED dashboards
####################################

# 1️⃣ Node Exporter Full (1860)
curl -L https://grafana.com/api/dashboards/1860/revisions/37/download \
  -o grafana/dashboards/node-exporter.json

# 2️⃣ JVM Micrometer (4701)
curl -L https://grafana.com/api/dashboards/4701/revisions/9/download \
  -o grafana/dashboards/jvm.json

# 3️⃣ Spring Boot Statistics (6756)
curl -L https://grafana.com/api/dashboards/6756/revisions/1/download \
  -o grafana/dashboards/spring-boot.json

####################################
# PATCH dashboards to match Prometheus
####################################

# JVM & Spring Boot → employee-app
sed -i 's/job=\\"\$job\\"/job=\\"employee-app\\"/g' grafana/dashboards/jvm.json
sed -i 's/job=\\"\$job\\"/job=\\"employee-app\\"/g' grafana/dashboards/spring-boot.json
sed -i 's/\$application/employee-availability-backend/g' grafana/dashboards/*.json

# Node Exporter → employee-node-exporter
sed -i 's/job=\\"\$job\\"/job=\\"employee-node-exporter\\"/g' grafana/dashboards/node-exporter.json

####################################
# Wait for Docker and start stack
####################################
until docker info >/dev/null 2>&1; do
  echo "Waiting for Docker..."
  sleep 5
done

docker compose up -d

echo "===== Monitoring bootstrap completed successfully ====="
