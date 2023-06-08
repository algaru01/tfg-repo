locals {
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

resource "aws_key_pair" "this" {
  key_name   = "test_asg"
  public_key = file("${path.cwd}/../../ssh-keys/test_asg.pub")
}

resource "aws_launch_template" "this" {
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = data.aws_ec2_instance_types.free_instance.instance_types[0]
  key_name = aws_key_pair.this.key_name

  user_data = filebase64("${path.cwd}/../scripts/init-script.sh")

  vpc_security_group_ids = [ aws_security_group.allow_http_ssh_icmp.id ]

  tags = {
    Name = "myASGLaunchTemplate"
  }
}

resource "aws_autoscaling_group" "this" {
  name                = "myAutoscalingGroup"
  vpc_zone_identifier = var.public_subnets
  target_group_arns   = var.target_group_arns

  launch_template {
    id = aws_launch_template.this.id
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  min_size = var.min_size
  max_size = var.max_size
}

/* resource "aws_autoscaling_policy" "this" {
  name                   = "myASGPolicy"

  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 2
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this.name
} */

resource "aws_security_group" "allow_http_ssh_icmp" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
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