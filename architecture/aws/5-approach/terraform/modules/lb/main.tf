locals {
  http_port    = 80
  ssh_port     = 22
  any_port     = 0
  any_protocol = -1
}

resource "aws_lb" "this" {
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = var.public_subnets_id
}

resource "aws_security_group" "allow_http" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn

  port     = local.http_port
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
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
  port        = var.auth_server_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/api/v1/auth/hello"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 90
    timeout             = 20
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "products" {
  port        = var.products_server_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/api/v1/products/hello"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 90
    timeout             = 20
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}