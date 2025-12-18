resource "aws_instance" "employee_app_server" {
  ami                    = var.employee_ami_id
  instance_type           = "t3.micro"
  key_name               = var.employee_key_pair_name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.employee_ec2_sg_id]

  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.employee_ec2_profile.name

  user_data = file("${path.module}/userdata.sh")

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "Employee-App-Server"
    Project = "Employee-App"
  }
}

# ----------------------------
# IAM Role for EC2 (SSM)
# ----------------------------
resource "aws_iam_role" "employee_ec2_role" {
  name = "employee-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "employee_ec2_ssm" {
  role       = aws_iam_role.employee_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "employee_ec2_profile" {
  name = "employee-ec2-profile"
  role = aws_iam_role.employee_ec2_role.name
}
