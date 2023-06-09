terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.62.0"
    }
/*     google-beta = {
      source = "hashicorp/google-beta"
      version = "4.63.1"
    } */
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

  subnets = ["10.0.0.0/24"]
  proxy_subnets   = ["10.1.0.0/24"]

  server_port = var.server_port
}

module "mig" {
  source = "./modules/mig"

  server_port = var.server_port
  subnet      = module.vpc.subnets[0]
}

module "lb" {
  source = "./modules/lb"

  vpc = module.vpc.vpc

  check_port             = var.server_port
  instance_group_backend = module.mig.instance_group

  depends_on = [ module.mig, module.vpc]
}