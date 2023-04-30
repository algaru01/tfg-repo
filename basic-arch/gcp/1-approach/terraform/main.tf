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

module "vm" {
  source = "./modules/vm"

  server_port = var.server_port
}

resource "google_compute_firewall" "allow_server_port" {
  name    = "server-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [var.server_port]
  }
  source_ranges = ["0.0.0.0/0"]
}