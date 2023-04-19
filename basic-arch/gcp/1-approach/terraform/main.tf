terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.62.0"
    }
  }
}

provider "google" {
  project = "basic-arch"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}