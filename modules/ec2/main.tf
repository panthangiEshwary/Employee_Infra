resource "aws_instance" "employee_app_server" {
  ami                         = var.employee_ami_id
  instance_type               = "t3.micro"
  key_name                    = var.employee_key_pair_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.employee_ec2_sg_id]
  associate_public_ip_address = true

  user_data = file("${path.module}/userdata.sh")

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "Employee-App-Server"
    Project = "Employee-App"
  }
}
