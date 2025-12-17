################################
# AWS & General
################################
variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

################################
# Network / Access
################################
variable "employee_my_ip_cidr" {
  type        = string
  description = "Your public IP in CIDR format (for SSH access)"
  default     = "0.0.0.0/0"
}

################################
# EC2
################################
variable "employee_key_pair_name" {
  type        = string
  description = "SSH key pair name for Employee EC2"
  default     = "Esh"
}

variable "employee_app_ami_id" {
  type        = string
  description = "AMI ID for Employee application EC2"
  default     = "ami-068c0051b15cdb816"
}

################################
# RDS
################################
variable "employee_db_master_username" {
  type        = string
  description = "Master username for Employee MySQL database"
  default     = "admin"
}

variable "employee_db_master_password" {
  type        = string
  description = "Master password for Employee MySQL database"
  sensitive   = true
  default     = "admin1234"
}
