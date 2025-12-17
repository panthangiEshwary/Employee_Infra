output "employee_ec2_sg_id" {
  description = "Security group ID for Employee EC2"
  value       = aws_security_group.employee_ec2_sg.id
}

output "employee_alb_sg_id" {
  description = "Security group ID for Employee ALB"
  value       = aws_security_group.employee_alb_sg.id
}

output "employee_rds_sg_id" {
  description = "Security group ID for Employee RDS"
  value       = aws_security_group.employee_rds_sg.id
}