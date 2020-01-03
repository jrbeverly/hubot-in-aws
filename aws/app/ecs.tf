# Service for running the AWS Account
resource "aws_ecs_cluster" "default" {
  name = "hubot-cluster"
  tags = local.tags
}

# Capacity
locals {
  ecs_cpu    = 256
  ecs_memory = 512
}

resource "aws_ecs_task_definition" "service" {
  family                   = "hubot"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  # IAM
  task_role_arn      = aws_iam_role.ecs_role.arn
  execution_role_arn = aws_iam_role.ecs_exec_role.arn

  # Capacity
  cpu    = local.ecs_cpu
  memory = local.ecs_memory

  container_definitions = jsonencode([
    {
      name = "hubot",

      cpu    = local.ecs_cpu,
      memory = local.ecs_memory,
      image  = local.ecr_repository_image,

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.logs.id,
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = local.logs_prefix,
        },
      },

      environment = [
        {
          name  = "HUBOT_SECRET"
          value = aws_secretsmanager_secret.default.name
        },
        {
          name  = "AWS_REGION"
          value = data.aws_region.current.name
        }
      ],
    }
  ])
}

resource "aws_ecs_service" "default" {
  name            = "hubot"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.service.arn

  desired_count = 0
  lifecycle {
    ignore_changes = [desired_count]
  }

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = [aws_subnet.main.id]
  }
}


