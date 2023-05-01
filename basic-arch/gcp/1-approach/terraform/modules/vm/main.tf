resource "google_compute_instance" "this" {
  name         = "my-instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata_startup_script = templatefile("${path.cwd}/../scripts/init-script.sh", {server_port = var.server_port})

  metadata = {
    ssh-keys = "ubuntu:${file("${path.cwd}/../../ssh-keys/gcp_keys.pub")}"
  }
}