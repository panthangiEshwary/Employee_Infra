#------------------------------
#RDS cannot live directly in a subnet.
#It needs a DB subnet group (a list of subnets).
#--------------------------------
resource "aws_db_subnet_group" "employee_db_subnet_group" {
  name       = "employee-db-subnet-group"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name    = "Employee-DB-Subnet-Group"
    Project = "Employee-App"
  }
}

#RDS Instance (Employee Database)
resource "aws_db_instance" "employee_db" {
  identifier        = "employee-db"
  engine            = "mysql"
  engine_version    = "8.0.43"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "employee_db"
  username = var.db_master_username
  password = var.db_master_password

  skip_final_snapshot = true
  multi_az            = false

  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.employee_db_subnet_group.name
  vpc_security_group_ids = [var.employee_rds_sg_id]

  backup_retention_period = 0

  tags = {
    Name    = "Employee-Database"
    Project = "Employee-App"
  }
}
