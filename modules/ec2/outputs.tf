output "ec2_id" {
  description = "Employee EC2 instance ID"
  value       = aws_instance.employee_app_server.id
}

output "public_ip" {
  description = "Employee EC2 public IP"
  value       = aws_instance.employee_app_server.public_ip
}

output "private_ip" {
  description = "Private IP of Employee App EC2"
  value       = aws_instance.employee_app_server.private_ip
}

