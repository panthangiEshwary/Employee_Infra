output "employee_alb_dns_name" {
  description = "DNS name of Employee ALB"
  value       = aws_lb.employee_alb.dns_name
}
