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

########################################################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_ec2_instance_types" "free_instance" {

  filter {
    name   = "free-tier-eligible"
    values = ["true"]
  }
}

#############################################################

module "vpc" {
  source = "./modules/vpc"

  cidr_block        = "10.0.0.0/16"
  public_subnets    = ["10.0.0.0/24"]
  availability_zone = ["eu-west-1a"]
}

resource "aws_security_group" "allow_http" {
  name   = "ec2_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = data.aws_ec2_instance_types.free_instance.instance_types[0]

  subnet_id              = module.vpc.public_subnets_id[0]
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p ${var.server_port} &
            EOF

  user_data_replace_on_change = true

  tags = {
    name = "MyFirstEC2"
  }
}