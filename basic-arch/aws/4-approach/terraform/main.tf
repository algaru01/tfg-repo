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

locals {
  asg_cidr_subnets = [ "10.0.0.0/24", "10.0.1.0/24" ]
}

module "vpc" {
  source = "./modules/vpc"

  cidr_block      = "10.0.0.0/16"
  public_subnets  = concat(local.asg_cidr_subnets, ["10.0.2.0/24", "10.0.3.0/24"])
  private_subnets = ["10.0.100.0/24", "10.0.101.0/24"]

  public_subnets_availability_zone  = ["eu-west-1a", "eu-west-1b", "eu-west-1a", "eu-west-1b"]
  private_subnets_availability_zone = ["eu-west-1a", "eu-west-1b"]
}

module "asg" {
  source = "./modules/asg"

  vpc_id         = module.vpc.vpc_id
  subnets = [module.vpc.public_subnets_id[0], module.vpc.public_subnets_id[1]]

  server_port = var.server_port
  db_address  = module.db.address
  db_user     = var.db_user
  db_password = var.db_password

  target_group_arns = [module.lb.main_target_group_arn]

  min_size         = 2
  max_size         = 5
  desired_capacity = 2

  depends_on = [
    module.db
  ]
}

module "lb" {
  source = "./modules/lb"

  vpc_id         = module.vpc.vpc_id
  public_subnets = [module.vpc.public_subnets_id[2], module.vpc.public_subnets_id[3]]
  server_port    = var.server_port
}

module "db" {
  source = "./modules/db"

  db_subnets = module.vpc.private_subnets_id
  vpc_id     = module.vpc.vpc_id

  servers_subnets = local.asg_cidr_subnets

  port = 3306

  username = var.db_user
  password = var.db_password
}