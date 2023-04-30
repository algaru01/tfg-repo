terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc"

  cidr_block        = "10.0.0.0/16"
  public_subnets    = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets   = ["10.0.100.0/24", "10.0.101.0/24"]

  public_subnets_availability_zone  = ["eu-west-1a", "eu-west-1b"]
  private_subnets_availability_zone = ["eu-west-1a", "eu-west-1b"]
}

module "asg" {
  source = "./modules/asg"

  vpc_id            = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets_id

  server_port = var.server_port
  db_address  = module.db.address
  db_user     = var.db_user
  db_password = var.db_password

  target_group_arns = [module.lb.main_target_group_arn]

  min_size = 2
  max_size = 5

  depends_on = [
    module.db
  ]
}

module "lb" {
  source = "./modules/lb"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets_id
  server_port    = var.server_port
}

module "db" {
  source = "./modules/db"

  db_subnets = module.vpc.private_subnets_id
  vpc_id     = module.vpc.vpc_id

  port = 3306

  username = var.db_user
  password = var.db_password
}