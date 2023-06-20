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

  services = ["compute.googleapis.com"]
}

module "vm" {
  source = "./modules/vm"

  server_port = var.server_port
  subnet      = module.vpc.subnets[0]
  number_vms  = 2
}

module "vpc" {
  source = "./modules/vpc"

  subnets = ["10.0.0.0/16"]

  server_port = var.server_port
}