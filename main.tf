module "vpc" {
  source = "./modules/vpc"

  vpc_cidr               = "10.0.0.0/16"
  public_subnet_az1_cidr = "10.0.1.0/24"
  public_subnet_az2_cidr = "10.0.2.0/24"
  az1                    = "us-east-1a"
  az2                    = "us-east-1b"
}

############################
# Security Groups
############################
module "security_groups" {
  source = "./modules/security_groups"

  vpc_id     = module.vpc.vpc_id
  my_ip_cidr = var.employee_my_ip_cidr
}

############################
# EC2 – Employee App Server
############################
module "ec2" {
  source = "./modules/ec2"

  employee_ami_id        = var.employee_app_ami_id
  employee_key_pair_name = var.employee_key_pair_name
  public_subnet_id       = module.vpc.public_subnet_ids[0]
  employee_ec2_sg_id = module.security_groups.employee_ec2_sg_id
<<<<<<< HEAD
=======
  backend_image = "ghcr.io/panthangiEshwary/employee-backend:30"
  frontend_image = "ghcr.io/panthangiEshwary/employee-frontend:30"
  GHCR_USER   = var.GHCR_USER
  GHCR_TOKEN  = var.GHCR_TOKEN
  db_host = module.rds.rds_endpoint
  db_port     = 3306
  db_name     = "employee_availability"
  db_user     = var.employee_db_master_username
  db_password = var.employee_db_master_password

>>>>>>> 85ca07b (files)
}

############################
# EC2 – Monitoring Server
############################
module "monitor_ec2" {
  source = "./modules/ec2_mon"

  monitor_ami_id   = var.monitor_ami_id
  key_pair_name    = var.employee_key_pair_name
  public_subnet_id = module.vpc.public_subnet_ids[0]
  monitor_sg_id    = module.security_groups.employee_monitor_sg_id

  app_private_ip   = module.ec2.private_ip
}

############################
# RDS – Employee Database
############################
module "rds" {
  source = "./modules/rds"

  public_subnet_ids      = module.vpc.public_subnet_ids
  employee_rds_sg_id = module.security_groups.employee_rds_sg_id
  db_master_username     = var.employee_db_master_username
  db_master_password     = var.employee_db_master_password
}

############################
# ALB – Application Load Balancer
############################
module "alb" {
  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id = module.security_groups.employee_alb_sg_id
  ec2_instance_id   = module.ec2.ec2_id
}
