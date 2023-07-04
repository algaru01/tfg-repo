terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.62.0"
    }
  }
}

provider "google" {
  credentials = file(var.service_credentials_location)

  project = "basic-arch-384210"
  region  = "europe-southwest1"
  zone    = "europe-southwest1-a"
}

module "services" {
  source = "./modules/services"

  services = ["compute.googleapis.com", "vpcaccess.googleapis.com", "secretmanager.googleapis.com"]
}

module "vpc" {
  source = "./modules/vpc"

  subnets       = ["10.0.0.0/24", "10.2.0.0/24"]
  proxy_subnets = ["10.1.0.0/24"]

  server_port = var.server_port
}

module "ar" {
  source = "./modules/ar"
}

module "cr" {
  source = "./modules/cr"

  location   = "europe-southwest1"
  project_id = "basic-arch-384210"

  ar_name = module.ar.name

  connector = module.vpc.connector

  products_port = 8080
  auth_port     = 8081

  db_address  = module.db.db_address
  db_port     = 5432
  db_user     = var.db_user
  db_password = var.db_password

  depends_on = [module.ar, module.db, module.services]
}

module "lb" {
  source = "./modules/lb"

  vpc = module.vpc.vpc

  check_port             = var.server_port
  products_backend_group = module.cr.products_network_endpoint_group_id
  auth_backend_group     = module.cr.auth_network_endpoint_group_id

  depends_on = [module.vpc]
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


module "jumpbox" {
  source = "./modules/jumpbox"

  vpc        = module.vpc.vpc
  subnetwork = module.vpc.public_subnets[1]
}