variable "public_subnet_ids" {
  description = "List of subnet IDs for DB subnet group"
  type        = list(string)
}

variable "db_master_username" {
  description = "Master username for RDS"
  type        = string
}

variable "db_master_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

variable "employee_rds_sg_id" {
  description = "Security group ID for RDS"
  type        = string
}
