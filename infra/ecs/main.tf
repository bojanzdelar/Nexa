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
          { AWS_REGION = data.aws_region.current.id }
          ) : {
          name  = key
          value = value
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "services" {
  for_each = var.services

  name            = "nexa-${each.key}"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.services[each.key].arn
  desired_count   = 0
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}
