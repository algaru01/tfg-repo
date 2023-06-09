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

module "vpc" {
  source = "./modules/vpc"

  cidr_block      = "10.0.0.0/16"
  public_subnets  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] //"10.0.200.0/28"
  private_subnets = ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  nat_subnet      = "10.0.104.0/24"

  public_subnets_availability_zone  = ["eu-west-1a", "eu-west-1b", "eu-west-1b", "eu-west-1a", "eu-west-1a"]
  private_subnets_availability_zone = ["eu-west-1a", "eu-west-1b", "eu-west-1a", "eu-west-1b"]
}

module "lb" {
  source = "./modules/lb"

  vpc_id               = module.vpc.vpc_id
  public_subnets_id    = [module.vpc.public_subnets_id[0], module.vpc.public_subnets_id[1]]
  auth_server_port     = var.auth_server_port
  products_server_port = var.products_server_port
}

module "ecs" {
  source = "./modules/ecs"

  region = "eu-west-1"

  vpc     = module.vpc.vpc_id
  subnets = [module.vpc.private_subnets_id[0], module.vpc.private_subnets_id[1]]

  lb_sg                        = module.lb.alb_sg
  lb_auth_target_group_arn     = module.lb.auth_target_group_arn
  lb_products_target_group_arn = module.lb.products_target_group_arn

  repository_url = module.ecr.ecr_repository_url

  auth_server_port     = var.auth_server_port
  products_server_port = var.products_server_port

  db_address  = module.db.address
  db_port     = 3306 //var
  db_user     = var.db_user
  db_password = var.db_password

  auth_url = module.lb.alb_dns_name
}

module "ecr" {
  source = "./modules/ecr"

}

module "db" {
  source = "./modules/db"

  subnet_ids = [module.vpc.private_subnets_id[2], module.vpc.private_subnets_id[3]]
  vpc_id     = module.vpc.vpc_id

  port = 3306

  username = var.db_user
  password = var.db_password
}

/* module "jumpbox" {
  source = "./modules/jumpbox"

  vpc_id         = module.vpc.vpc_id
  jumpbox_subnet = module.vpc.public_subnets_id[2]
} */