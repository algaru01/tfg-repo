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

  services = ["compute.googleapis.com", "servicenetworking.googleapis.com"]
}

module "vpc" {
  source = "./modules/vpc"

  subnets       = ["10.0.0.0/24"]
  proxy_subnets = ["10.1.0.0/24"]

  server_port = var.server_port
}

module "mig" {
  source = "./modules/mig"

  server_port = var.server_port
  subnet      = module.vpc.subnets[0]

  db_address  = module.db.db_address
  db_user     = var.db_user
  db_password = var.db_password

}

module "lb" {
  source = "./modules/lb"

  vpc = module.vpc.vpc

  backend_port           = module.mig.named_port
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

    depends_on = [
    module.vpc
  ]
}