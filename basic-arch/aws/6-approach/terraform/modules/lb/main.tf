locals {
  http_port     = 80
  ssh_port      = 22
  any_port      = 0
  any_protocol  = -1
  tcp_protocol  = "tcp"
  http_protocol = "HTTP"
  all_ips       = ["0.0.0.0/0"]
}

resource "aws_lb" "this" {
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = var.public_subnets_id

  tags = {
    Name = "myLoadBalancer"
  }
}

resource "aws_security_group" "allow_http" {
  vpc_id = var.vpc_id

  tags = {
    Name = "myLbSecurityGroup"
  }

  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn

  port     = local.http_port
  protocol = local.http_protocol

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }

  tags = {
    Name = "myLbListener-HTTP"
  }
}

resource "aws_lb_listener_rule" "auth" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/api/v1/auth/*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth.arn
  }
}

resource "aws_lb_listener_rule" "products" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 101

  condition {
    path_pattern {
      values = ["/api/v1/product/*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.products.arn
  }
}

resource "aws_lb_target_group" "auth" {
  port     = var.auth_server_port
  protocol = local.http_protocol
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/api/v1/auth/hello"
    protocol            = local.http_protocol
    matcher             = "200"
    interval            = 90
    timeout             = 20
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "products" {
  port     = var.products_server_port
  protocol = local.http_protocol
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/api/v1/products/hello"
    protocol            = local.http_protocol
    matcher             = "200"
    interval            = 90
    timeout             = 20
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}