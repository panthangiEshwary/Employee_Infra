terraform {
  backend "s3" {
    bucket         = "employee-terraform-state"
    key            = "employee/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-table"
  }
}