resource "aws_instance" "monitor_instance" {
  ami                         = var.monitor_ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [var.monitor_sg_id]
  associate_public_ip_address = true

   user_data = templatefile("${path.module}/userdata.sh", {
    prometheus_config = templatefile("${path.module}/prometheus.yml.tpl", {
      app_private_ip = var.app_private_ip
    })

    alert_rules_config  = file("${path.module}/alert-rules.yml.tpl")
    alertmanager_config = file("${path.module}/alertmanager.yml.tpl")
    docker_compose      = file("${path.module}/docker-compose.yml.tpl")
  })

  tags = {
    Name = "Monitoring"
  }
}