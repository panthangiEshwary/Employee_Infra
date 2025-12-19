output "public_ip" {
  description = "Public IP of Monitoring EC2"
  value       = aws_instance.monitor_instance.public_ip
}