variable "monitor_ami_id" {
  description = "AMI ID for Monitoring instance (Ubuntu 22.04 recommended)"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "app_private_ip" {
  description = "Private IP of Employee App EC2"
  type        = string
}

variable "key_pair_name" {
  description = "EC2 key pair name"
  default = "Esh"
  type        = string
}

variable "monitor_sg_id" {
  description = "Security group ID for monitoring instance"
  type        = string
}

