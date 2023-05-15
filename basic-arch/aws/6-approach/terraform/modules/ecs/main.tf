resource "aws_ecs_cluster" "staging" {
  name = "${var.prefix}-cluster"
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.prefix}-tasks-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.vpc

  ingress {
    protocol        = "tcp"
    from_port       = 8080 //var.server_port
    to_port         = 8080 //var.server_port
    cidr_blocks     = ["0.0.0.0/0"]
    //security_groups = [var.lb_sg]
  }

/*     ingress {
    protocol        = "tcp"
    from_port       = 80 //var
    to_port         = 80 //var
    cidr_blocks     = ["0.0.0.0/0"]
    //security_groups = [var.lb_sg]
  } */

  # Al ser ICMP from_port indica el tipo de mensaje y to_port el código. En este caso un echo-request para hacer ping.
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
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





resource "aws_ecs_task_definition" "miTaskDefinition" {
  family                   = "${var.prefix}-TASK-DEFINITION"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions    = templatefile("${path.cwd}/../files/app.json.tpl", {
          aws_ecr_repository = var.repository_url
          tag                = "latest"
          app_port           = 8080
          region             = "eu-west-1"  //var.region
          prefix             = "${var.prefix}"
          envvars            = {"DATABASE_ADDRESS"=var.db_address, "DATABASE_PORT"=var.db_port, "DATABASE_USER"=var.db_user, "DATABASE_PASSWORD"=var.db_password}
          port               = 8080  //var.server_port
      })
  tags = {
    Environment = "staging"
    Application = "${var.prefix}-app"
  }
}

resource "aws_ecs_service" "miServicio" {
  name            = "${var.prefix}-SERVICIO"
  cluster         = aws_ecs_cluster.staging.id
  task_definition = aws_ecs_task_definition.miTaskDefinition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = var.public_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = "${var.prefix}-app"
    container_port   = 8080 //var.server_port
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]

  tags = {
    Environment = "staging"
    Application = "${var.prefix}-app"
  }
}

resource "aws_cloudwatch_log_group" "dummyapi" {
  name = "${var.prefix}-log-group"

  tags = {
    Environment = "staging"
    Application = "${var.prefix}-app"
  }
}

