# -------------------------------
# Define everything that comes from outside.
#These are placeholders.
#Actual values come from root main.tf later.
# -------------------------------

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_az1_cidr" {
  description = "CIDR for public subnet AZ1"
  type        = string
}

variable "public_subnet_az2_cidr" {
  description = "CIDR for public subnet AZ2"
  type        = string
}

variable "az1" {
  description = "Availability zone 1"
  type        = string
}

variable "az2" {
  description = "Availability zone 2"
  type        = string
}
