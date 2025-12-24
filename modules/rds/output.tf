output "employee_rds_endpoint" {
  description = "Full endpoint for the Employee MySQL database"
  value       = aws_db_instance.employee_db.endpoint
}

output "employee_rds_instance_id" {
  description = "Identifier of the Employee RDS instance"
  value       = aws_db_instance.employee_db.identifier
}

output "employee_db_name" {
  description = "Employee database name"
  value       = aws_db_instance.employee_db.db_name
}

output "employee_db_port" {
  description = "Employee database port"
  value       = aws_db_instance.employee_db.port
}

output "employee_rds_instance_arn" {
  description = "ARN of the Employee RDS instance"
  value       = aws_db_instance.employee_db.arn
}

