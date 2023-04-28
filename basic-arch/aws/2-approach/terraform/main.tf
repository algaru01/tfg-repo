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

  cidr_block        = "10.0.0.0/16"
  public_subnets    = ["10.0.0.0/24", "10.0.1.0/24"]
}

module "ec2" {
  source = "./modules/ec2"
  
  number_instances = 2

  vpc     = module.vpc.vpc_id
  subnet  = module.vpc.public_subnets[0]

  server_port = var.server_port
}