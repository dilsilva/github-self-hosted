

resource "aws_ecs_cluster" "main" {
  name = "${var.project}-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_capacity_provider" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 3


  force_new_deployment = true

  network_configuration {
    subnets         = [for subnet in var.private_subnets : subnet]
    security_groups = [aws_security_group.ecs.id]
  }

  triggers = {
    redeployment = timestamp()
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = var.app_name
    container_port   = 80
  }

  depends_on = [aws_lb.ecs_alb]
}


resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.task-execution-role.arn

  container_definitions = jsonencode([
    {
      name         = var.app_name
      image        = var.app_image
      cpu          = 256
      memory       = 512
      network_mode = "awsvpc"
      essential    = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/${var.app_name}",
          awslogs-region        = var.region,
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  ephemeral_storage {
    size_in_gib = "50"
  }

}