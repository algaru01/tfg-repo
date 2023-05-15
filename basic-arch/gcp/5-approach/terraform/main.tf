terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
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

  services = ["compute.googleapis.com"]
}

module "vpc" {
  source = "./modules/vpc"

  subnets = ["10.0.0.0/16", "10.1.0.0/24"]

  server_port = var.server_port
}

module "mig" {
  source = "./modules/mig"

  server_port = var.server_port
  subnet      = module.vpc.public_subnets[0]

  db_address  = module.db.db_address
  db_user     = var.db_user
  db_password = var.db_password
}

module "lb" {
  source = "./modules/lb"

  check_port             = var.server_port
  instance_group_backend = module.mig.instance_group

  depends_on = [
    module.mig,
    module.vpc
  ]
}

module "db" {
  source = "./modules/db"

  vpc         = module.vpc.vpc
  db_user     = var.db_user
  db_password = var.db_password
}

module "jumpbox" {
  source = "./modules/jumpbox"

  vpc        = module.vpc.vpc
  subnetwork = module.vpc.public_subnets[1]
}