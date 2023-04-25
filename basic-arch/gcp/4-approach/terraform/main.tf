terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.62.0"
    }
  }
}

provider "google" {
  credentials = file("../../credentials/basic-arch-384210.json")

  project = "basic-arch-384210"
  region  = "europe-southwest1"
  zone    = "europe-southwest1-a"
}

module "services" {
  source = "./modules/services"

  services = [ "compute.googleapis.com" ]
}

module "vpc" {
  source = "./modules/vpc"

  public_subnets = [ "10.0.0.0/16" ]

  server_port = var.server_port
}

module "mig" {
  source = "./modules/mig"

  server_port = var.server_port
  subnet = module.vpc.public_subnets[0]

  db_address     = module.db.db_address
  db_user        = var.db_user
  db_password = var.db_password 
}

module "lb" {
  source = "./modules/lb"

  server_port = var.server_port
  instance_group = module.mig.instance_group

  depends_on = [
    module.mig
  ]
}

module "db" {
  source = "./modules/db"

  vpc = module.vpc.vpc
  db_user = var.db_user
  db_password = var.db_password
}