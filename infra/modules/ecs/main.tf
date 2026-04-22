resource "aws_ecs_cluster" "this" {
  name = "nexa-cluster"
}

resource "aws_ecs_task_definition" "services" {
  for_each = var.services

  family                   = "nexa-${each.key}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task[each.key].arn

  container_definitions = jsonencode([
    {
      name  = each.key
      image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.id}.amazonaws.com/nexa-${each.key}:latest"

      portMappings = [
        {
          containerPort = var.container_port
        }
      ]

      environment = [
        for key, value in merge(
          each.value.env,
          {
            PORT          = tostring(var.container_port)
            ORIGIN_SECRET = var.origin_secret
            AWS_REGION    = data.aws_region.current.id
          }
          ) : {
          name  = key
          value = value
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.services[each.key].name
          awslogs-region        = data.aws_region.current.id
          awslogs-stream-prefix = each.key
        }
      }
    }
  ])
}

resource "aws_ecs_service" "services" {
  for_each = var.services

  name            = "nexa-${each.key}"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.services[each.key].arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  dynamic "load_balancer" {
    for_each = var.enable_alb && contains(keys(var.target_group_arns), each.key) ? [1] : []

    content {
      target_group_arn = var.target_group_arns[each.key]
      container_name   = each.key
      container_port   = var.container_port
    }
  }

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}

resource "aws_cloudwatch_log_group" "services" {
  for_each = var.services

  name              = "/ecs/nexa-${each.key}"
  retention_in_days = 30
}
