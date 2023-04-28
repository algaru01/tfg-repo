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
  availability_zone = ["eu-west-1a", "eu-west-1b"]
}

module "asg" {
  source = "./modules/asg"

  vpc_id            = module.vpc.vpc_id
  public_subnets_id = module.vpc.public_subnets_id
  server_port       = var.server_port

  target_group_arns = [module.lb.main_target_group_arn]

  min_size = 2
  max_size = 5
}

module "lb" {
  source = "./modules/lb"

  vpc_id            = module.vpc.vpc_id
  public_subnets_id = module.vpc.public_subnets_id
  server_port       = var.server_port
}

