data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_ec2_instance_types" "free_instance" {

  filter {
    name   = "free-tier-eligible"
    values = ["true"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = "test_asg"
  public_key = file("${path.cwd}/../../ssh-keys/test_asg.pub")
}

resource "aws_security_group" "allow_http" {
  name   = "ec2_sg"
  vpc_id = var.vpc

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //Allow internal traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.vpc_cidr_block]
  }
}

resource "aws_network_interface" "this" {
  subnet_id = var.subnet
  security_groups = [ aws_security_group.allow_http.id ]
}

resource "aws_instance" "ec2" {
  count = var.number_instances != null ? var.number_instances : 0

  instance_type = data.aws_ec2_instance_types.free_instance.instance_types[0]
  ami           = data.aws_ami.ubuntu.id
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.this.id
  }
  key_name = aws_key_pair.this.key_name

  
  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p ${var.server_port} &
            EOF
  user_data_replace_on_change = true

  tags = {
    name = "MyEC2"
  }
}