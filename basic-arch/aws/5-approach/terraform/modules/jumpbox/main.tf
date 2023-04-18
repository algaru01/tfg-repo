resource "aws_security_group" "this" {
  description = "Allow SSH to the jumpbox"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = "myJumpboxKey"
  public_key = file("${path.cwd}/test_jumpbox.pub")
}

resource "aws_instance" "jumpbox" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = data.aws_ec2_instance_types.free_instance.instance_types[0]

  key_name = aws_key_pair.this.key_name 
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id = var.jumpbox_subnet
  associate_public_ip_address = true

  tags = {
    name  = "myJumpbox"
  }
}

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