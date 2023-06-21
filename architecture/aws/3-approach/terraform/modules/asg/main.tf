locals {
  ssh_port      = 22
  any_port      = 0
  tcp_protocol  = "tcp"
  icmp_protocol = "icmp"
  any_protocol  = -1
  all_ips       = ["0.0.0.0/0"]
}

resource "aws_key_pair" "this" {
  key_name   = "myKey"
  public_key = file("${path.cwd}/../../ssh-keys/test_asg.pub")
}

resource "aws_launch_template" "this" {
  image_id               = "ami-05ba42ed0dd051449" #1.0.0
  instance_type          = data.aws_ec2_instance_types.free_instance.instance_types[0]
  vpc_security_group_ids = [aws_security_group.allow_http_ssh_icmp.id]

  user_data = base64encode(templatefile("${path.cwd}/../scripts/launch-server.sh", {
    db_address  = var.db_address,
    db_user     = var.db_user,
    db_password = var.db_password
  }))
  key_name = aws_key_pair.this.key_name

  # Obliga a Terraform a crear una nueva Instancia antes de crear una nueva al actualizar este recurso
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "myASGLaunchTemplate"
  }
}

resource "aws_autoscaling_group" "this" {
  name                = "myAutoscalingGroup"
  vpc_zone_identifier = var.subnets
  target_group_arns   = var.target_group_arns

  launch_template {
    id = aws_launch_template.this.id
  }

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  health_check_type         = "ELB"
  health_check_grace_period = 300
}

resource "aws_security_group" "allow_http_ssh_icmp" {
  vpc_id = var.vpc_id

  description = "Allow HTTP, SSH and ICMP"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  ingress {
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }

  # Al ser ICMP from_port indica el tipo de mensaje y to_port el código. En este caso un echo-request para hacer ping.
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = local.icmp_protocol
    cidr_blocks = local.all_ips
  }

  tags = {
    Name = "myASGSecurityGroup"
  }
}

data "aws_ec2_instance_types" "free_instance" {

  filter {
    name   = "free-tier-eligible"
    values = ["true"]
  }
}