# -------------------------------
# VPC
# -------------------------------
resource "aws_vpc" "employee_vpc" {
cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Employee_vpc"
  }
}

# -------------------------------
# Public Subnet AZ1
#aws_vpc.employee_vpc.id → link to VPC
#var.public_subnet_az1_cidr → input variable
#var.az1 → input variable
# -------------------------------
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.employee_vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "EmployeePublicSubnet-AZ1"
  }
}

# -------------------------------
# Public Subnet AZ2
# -------------------------------
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.employee_vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "EmployeePublicSubnet-AZ2"
  }
}

# -------------------------------
# Internet Gateway
#IGW must attach to VPC ID
# -------------------------------
resource "aws_internet_gateway" "employee_igw" {
  vpc_id = aws_vpc.employee_vpc.id
  tags = {
    Name = "Employee-IGW"
  }
}

# -------------------------------
# Public Route Table
#Route table uses:
#VPC ID
#IGW ID
# -------------------------------
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.employee_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.employee_igw.id
  }

  tags = {
    Name = "EmployeePublicRT"
  }
}

# -------------------------------
# Associate Route Table with Public Subnets
# -------------------------------
resource "aws_route_table_association" "public_subnet_az1_rt_assoc" {
  subnet_id      =  aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az2_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}