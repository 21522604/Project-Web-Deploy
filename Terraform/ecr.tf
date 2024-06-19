resource "aws_ecr_repository" "backend" {
  name                 = "backend"
}

resource "aws_ecr_repository" "frontendadmin" {
  name                 = "frontendadmin"
}

resource "aws_ecr_repository" "frontendcustomer" {
  name                 = "frontendcustomer"
}