resource "aws_lb" "employee_alb" {
  name               = "employee-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [var.alb_sg_id]
  subnets         = var.public_subnet_ids

  tags = {
    Name    = "Employee-ALB"
    Project = "Employee-App"
  }
}

resource "aws_lb_target_group" "employee_tg" {
  name     = "employee-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/health"
  }

  tags = {
    Name = "Employee-TG"
  }
}

resource "aws_lb_target_group_attachment" "employee_ec2_attach" {
  target_group_arn = aws_lb_target_group.employee_tg.arn
  target_id        = var.ec2_instance_id
  port             = 80
}

resource "aws_lb_listener" "employee_listener" {
  load_balancer_arn = aws_lb.employee_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.employee_tg.arn
  }
}

