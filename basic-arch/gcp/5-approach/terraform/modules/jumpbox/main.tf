
resource "google_compute_instance" "bastion_host" {
  name         = "my-bastion-host"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    subnetwork = var.subnetwork
    access_config {
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${path.cwd}/../../ssh-keys/gcp_keys.pub")}"
  }
}