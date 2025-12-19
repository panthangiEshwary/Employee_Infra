resource "aws_instance" "monitor_instance" {
  ami                         = var.monitor_ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [var.monitor_sg_id]
  associate_public_ip_address = true

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "Monitoring"
  }
}