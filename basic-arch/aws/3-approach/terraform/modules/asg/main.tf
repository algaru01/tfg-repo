locals {
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

resource "aws_launch_template" "this" {
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = data.aws_ec2_instance_types.free_instance.instance_types[0]
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data = filebase64("${path.cwd}/init-script.sh")

  tags = {
    Name = "myASGLaunchTemplate"
  }
}

resource "aws_autoscaling_group" "this" {
  name                = "myAutoscalingGroup"
  vpc_zone_identifier = var.public_subnets_id
  target_group_arns   = var.target_group_arns

  launch_template {
    id = aws_launch_template.this.id
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  min_size = var.min_size
  max_size = var.max_size
}

resource "aws_security_group" "allow_http" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  tags = {
    Name = "myASGSecurityGroup"
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