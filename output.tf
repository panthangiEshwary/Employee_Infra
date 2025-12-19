output "employee_app_public_ip" {
  description = "Public IP of Employee application EC2"
  value       = module.ec2.public_ip
}

output "employee_app_url" {
  description = "Employee application URL (Spring Boot on port 8080)"
  value       = "http://${module.ec2.public_ip}:8080"
}

output "frontend_url" {
  value = "http://${module.ec2.public_ip}"
}

output "backend_hello_url" {
  value = "http://${module.ec2.public_ip}:8080/hello"
}

output "backend_health_url" {
  value = "http://${module.ec2.public_ip}:8080/health"
}

output "backend_prometheus_metrics" {
  value = "http://${module.ec2.public_ip}:8080/actuator/prometheus"
}

output "grafana_url" {
  value = "http://${module.monitor_ec2.public_ip}:3000"
}

output "prometheus_url" {
  value = "http://${module.monitor_ec2.public_ip}:9090"
}

output "alertmanager_url" {
  value = "http://${module.monitor_ec2.public_ip}:9093"
}

output "n8n_url" {
  value = "http://${module.monitor_ec2.public_ip}:5678"
}

output "employee_rds_endpoint" {
  description = "Employee RDS endpoint"
  value       = module.rds.employee_rds_endpoint
}

output "employee_alb_url" {
  description = "Employee ALB URL"
  value       = "http://${module.alb.employee_alb_dns_name}"
}

