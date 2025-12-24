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


