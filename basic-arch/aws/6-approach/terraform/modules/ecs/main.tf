resource "aws_ecs_cluster" "staging" {
  name = "${var.prefix}-cluster"
}

resource "aws_security_group" "allow_from_alb" {
  name        = "${var.prefix}-tasks-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.vpc

/*   ingress {
    protocol        = "tcp"
    from_port       = var.auth_server_port
    to_port         = var.auth_server_port
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [var.lb_sg]
  }

    ingress {
    protocol        = "tcp"
    from_port       = var.products_server_port
    to_port         = var.products_server_port
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [var.lb_sg]
  } */

  ingress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.prefix}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "auth" {
  family                   = "${var.prefix}-AUTH-TASK-DEFINITION2"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions    = templatefile("${path.cwd}/../files/app.json.tpl", {
          name               = "${var.prefix}-auth-service"
          aws_ecr_repository = var.repository_url
          tag                = "auth-micro"
          app_port           = var.auth_server_port
          region             = var.region
          prefix             = "${var.prefix}"
          envvars            = {"DATABASE_ADDRESS"=var.db_address, "DATABASE_PORT"=var.db_port, "DATABASE_USER"=var.db_user, "DATABASE_PASSWORD"=var.db_password}
          port               = var.auth_server_port
      })
}

resource "aws_ecs_task_definition" "products" {
  family                   = "${var.prefix}-PRODUCTS-TASK-DEFINITION2"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions    = templatefile("${path.cwd}/../files/app.json.tpl", {
          name               = "${var.prefix}-products-service"
          aws_ecr_repository = var.repository_url
          tag                = "products-micro"
          app_port           = var.products_server_port
          region             = var.region
          prefix             = "${var.prefix}"
          envvars            = {"DATABASE_ADDRESS"=var.db_address, "DATABASE_PORT"=var.db_port, "DATABASE_USER"=var.db_user, "DATABASE_PASSWORD"=var.db_password, "AUTH_URL"=var.auth_url}
          port               = var.products_server_port
      })
}

resource "aws_ecs_service" "auth" {
  name            = "${var.prefix}-AUTH-SERVICE"
  cluster         = aws_ecs_cluster.staging.id
  task_definition = aws_ecs_task_definition.auth.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.allow_from_alb.id]
    subnets          = var.subnets
    //assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.lb_auth_target_group_arn
    container_name   = "${var.prefix}-auth-service"
    container_port   = var.auth_server_port
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_ecs_service" "products" {
  name            = "${var.prefix}-PRODUCTS-SERVICE"
  cluster         = aws_ecs_cluster.staging.id
  task_definition = aws_ecs_task_definition.products.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.allow_from_alb.id]
    subnets          = var.subnets
    //assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.lb_products_target_group_arn
    container_name   = "${var.prefix}-products-service"
    container_port   = var.products_server_port
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role, aws_ecs_service.auth]
}

resource "aws_cloudwatch_log_group" "this" {
  name = "${var.prefix}-log-group"
}

