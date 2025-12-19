#################################
# EC2 Security Group
#This module will:
#Attach to VPC
#Allow:
#SSH (22)
#Application (8080)
#Grafana (3000)
#Prometheus (9090)
#Allow all outbound traffic#EC2, ALB, RDS will reuse this SG
#################################
resource "aws_security_group" "employee_ec2_sg" {
  name        = "employee_ec2_sg"
  description = "Allow SSH and application access to EC2"
  vpc_id      = var.vpc_id

  # SSH access (only from your IP)
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  # Application access (Spring Boot)
  ingress {
    description = "Employee App access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Frontend (Angular / Nginx)
  ingress {
    description = "Frontend HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound - allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Employee-EC2-SG"
    Project = "Employee-App"
  }
}

#################################
# ALB Security Group
#################################
resource "aws_security_group" "employee_alb_sg" {
  name        = "employee-alb-sg"
  description = "Allow HTTP/HTTPS traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Employee-ALB-SG"
    Project = "Employee-App"
  }
}

#################################
# RDS Security Group
#################################
resource "aws_security_group" "employee_rds_sg" {
  name        = "employee-rds-sg"
  description = "Allow database access from EC2 only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL access from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.employee_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Employee-RDS-SG"
    Project = "Employee-App"
  }
}

#################################
# Monitoring Security Group
#################################
#################################
# Monitoring Security Group
# Used by:
# - Monitoring EC2 instance
# Services:
# - Grafana
# - Prometheus
# - Alertmanager
# - n8n
#################################
resource "aws_security_group" "employee_monitor_sg" {
  name        = "employee-monitor-sg"
  description = "Allow monitoring tools access"
  vpc_id      = var.vpc_id

  # SSH access (only from your IP)
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  # Grafana
  ingress {
    description = "Grafana UI"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Prometheus
  ingress {
    description = "Prometheus UI"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Alertmanager
  ingress {
    description = "Alertmanager UI"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # n8n
  ingress {
    description = "n8n UI"
    from_port   = 5678
    to_port     = 5678
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound - allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Employee-Monitor-SG"
    Project = "Employee-App"
  }
}