packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "basic-example" {
  project_id = "basic-arch-384210"
  source_image = "ubuntu-1804-bionic-v20230418"
  machine_type = "e2-micro"
  ssh_username = "ubuntu"
  zone = "europe-southwest1-a"
}

build {

  sources = ["sources.googlecompute.basic-example"]

  provisioner "shell" {
    script = "./init-script.sh"
  }

  provisioner "file" {
    source      = "./demo-1.0.0-SNAPSHOT.jar"
    destination = "/home/ubuntu/src/demo-1.0.0-SNAPSHOT.jar"
  }
}