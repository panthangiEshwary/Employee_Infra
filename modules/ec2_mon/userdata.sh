#!/bin/bash
set -euxo pipefail

LOG_FILE=/var/log/monitoring-bootstrap.log
exec > >(tee -a $LOG_FILE) 2>&1

echo "===== Monitoring bootstrap started ====="

####################################
# System update & dependencies
####################################
dnf update -y

# Fix curl conflict (AL2023 specific)
dnf remove -y curl-minimal || true
dnf install -y curl --allowerasing

####################################
# Install Docker
####################################
dnf install -y docker
systemctl enable docker
systemctl start docker

# Allow ec2-user to run docker
usermod -aG docker ec2-user

####################################
# Install Docker Compose v2 (plugin)
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
# Grafana provisioning
####################################
cat <<EOF > grafana/provisioning/datasources/prometheus.yml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
EOF

cat <<EOF > grafana/provisioning/dashboards/dashboards.yml
apiVersion: 1
providers:
  - name: Employee Dashboards
    folder: Employee
    type: file
    options:
      path: /var/lib/grafana/dashboards
EOF

####################################
# Download Grafana dashboards
####################################
curl -L https://grafana.com/api/dashboards/1860/revisions/37/download \
  -o grafana/dashboards/node-exporter.json

curl -L https://grafana.com/api/dashboards/4701/revisions/9/download \
  -o grafana/dashboards/jvm.json

curl -L https://grafana.com/api/dashboards/6756/revisions/1/download \
  -o grafana/dashboards/spring-boot.json

# Remove dashboard input prompts
sed -i 's/"__inputs": \[[^]]*\]/"__inputs": []/g' grafana/dashboards/*.json

####################################
# Wait for Docker and start stack
####################################
until docker info >/dev/null 2>&1; do
  echo "Waiting for Docker..."
  sleep 5
done

docker compose up -d

echo "===== Monitoring bootstrap completed successfully ====="
