packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "my-tfg-linux-1.0.0-2"
  instance_type = "t2.micro"
  region        = "eu-west-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] #Canonical
  }
  ssh_username = "ubuntu"
}

build {

  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    script = "./init-script.sh" #Actualiza el sistema e instala openjdk-17
  }

  provisioner "file" {
    source      = "./demo-1.0.0-SNAPSHOT.jar"
    destination = "/home/ubuntu/src/demo-1.0.0-SNAPSHOT.jar"
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}