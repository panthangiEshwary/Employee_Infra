#!/bin/bash

echo "========== Employee App EC2 Bootstrap Started =========="

# --------------------------------------------------
# Update system
# --------------------------------------------------
yum update -y

# --------------------------------------------------
# Install required packages
# NOTE: Do NOT install curl (AL2023 already has curl-minimal)
# --------------------------------------------------
yum install -y docker git wget || true

# --------------------------------------------------
# Start & enable Docker
# --------------------------------------------------
systemctl start docker
systemctl enable docker

# Allow ec2-user to run docker
usermod -aG docker ec2-user

# --------------------------------------------------
# Install Node Exporter
# Exposes metrics at :9100/metrics
# --------------------------------------------------
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
systemctl start node_exporter
systemctl enable node_exporter

# --------------------------------------------------
# Placeholder for Application Deployment
# --------------------------------------------------
mkdir -p /opt/employee-app
echo "Application EC2 ready. Awaiting deployment via CI/CD." > /opt/employee-app/README.txt

echo "========== Employee App EC2 Bootstrap Completed =========="
