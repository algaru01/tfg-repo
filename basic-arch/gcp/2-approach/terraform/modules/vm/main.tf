
resource "google_compute_instance" "this" {
  count = var.number_vms

  name = "my-instance-${count.index}"

  machine_type = "e2-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  network_interface {
    subnetwork = var.subnet
    access_config {
      //Auto assign public IP
    }
  }
  metadata = {
    ssh-keys = "ubuntu:${file("${path.cwd}/../../ssh-keys/gcp_keys.pub")}"
  }

  metadata_startup_script   = templatefile("${path.cwd}/../scripts/init-script.sh", { server_port = var.server_port })
  allow_stopping_for_update = true
}