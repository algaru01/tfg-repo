locals {
  any_port     = 0
  any_protocol = -1
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

resource "aws_db_subnet_group" "this" {
  subnet_ids = var.subnet_ids

  tags = {
    Name = "MyDBSubnetGroup"
  }
}

resource "aws_security_group" "allow_all_inbound" {
  name        = "main_rds_sg"
  description = "Allow all inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips #Quizás poner la subnet pública del asg?
  }

  /*   egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  } */

  tags = {
    Name = "myDBSecurityGroup"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "my-rds-tfg"
  db_name                = "student"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  port                   = var.port
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.allow_all_inbound.id]

  username = var.username
  password = var.password
}