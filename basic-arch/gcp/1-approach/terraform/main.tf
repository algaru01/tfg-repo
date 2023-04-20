terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.62.0"
    }
  }
}

provider "google" {
  credentials = file("../../credentials/basic-arch-384210-f9d25d4a7b5e.json")

  project = "basic-arch-384210"
  region  = "europe-southwest1"
  zone    = "europe-southwest1-a"
}

module "vm" {
  source = "./modules/vm"

  server_port = var.server_port
}

resource "google_compute_firewall" "flask" {
  name    = "flask-app-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [var.server_port]
  }
  source_ranges = ["0.0.0.0/0"]
}