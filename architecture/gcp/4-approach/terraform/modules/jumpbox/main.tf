
resource "google_compute_instance" "jumpbox_host" {
  name = "my-jumpbox-host"

  machine_type = "e2-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-focal-v20230616"
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