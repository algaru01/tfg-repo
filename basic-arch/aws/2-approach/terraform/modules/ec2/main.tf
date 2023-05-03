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

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_instance" "ec2" {
  count = var.number_instances != null ? var.number_instances : 0

  ami           = data.aws_ami.ubuntu.id
  instance_type = data.aws_ec2_instance_types.free_instance.instance_types[0]

  subnet_id              = var.subnet
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  key_name = aws_key_pair.this.key_name

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p ${var.server_port} &
            EOF

  user_data_replace_on_change = true

  tags = {
    name = "MyFirstEC2"
  }
}