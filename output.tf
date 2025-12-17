output "employee_app_public_ip" {
  description = "Public IP of Employee application EC2"
  value       = module.ec2.public_ip
}

output "employee_app_url" {
  description = "Employee application URL (Spring Boot on port 8080)"
  value       = "http://${module.ec2.public_ip}:8080"
}

output "employee_rds_endpoint" {
  description = "Employee RDS endpoint"
  value       = module.rds.employee_rds_endpoint
}

output "employee_alb_url" {
  description = "Employee ALB URL"
  value       = "http://${module.alb.employee_alb_dns_name}"
}
