# AMI ID for Employee EC2
variable "employee_ami_id" {
  description = "AMI ID for Employee application EC2"
  type        = string
}

# Key pair name
variable "employee_key_pair_name" {
  description = "SSH key pair name for Employee EC2"
  type        = string
}

# Public subnet ID
variable "public_subnet_id" {
  description = "Public subnet ID where EC2 will be launched"
  type        = string
}

# EC2 security group ID
variable "employee_ec2_sg_id" {
  description = "Security group ID for Employee EC2"
  type        = string
}

variable "docker_image" {
  description = "Docker image to run on EC2 (provided by CI/CD)"
  type        = string
  default     = ""
}

variable "GHCR_TOKEN" {
  type = string
}

variable "GHCR_USER" {
  type = string
}

variable "backend_image" {
  type = string
}

variable "frontend_image" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_port" {
  type = number
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}
