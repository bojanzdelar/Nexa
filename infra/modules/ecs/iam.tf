resource "aws_iam_role" "ecs_execution" {
  name = "nexa-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_exec_attach" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task" {
  for_each = var.services

  name = "nexa-${each.key}-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "ecs_task" {
  for_each = var.services

  role = aws_iam_role.ecs_task[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        for table in each.value.dynamodb_tables : {
          Effect = "Allow"
          Action = ["dynamodb:*"]
          Resource = [
            "arn:aws:dynamodb:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:table/${table}",
            "arn:aws:dynamodb:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:table/${table}/index/*"
          ]
        }
      ],
      each.key == "search-service" && var.enable_opensearch ? [
        {
          Effect   = "Allow"
          Action   = ["es:ESHttp*"]
          Resource = "${var.opensearch_domain_arn}/*"
        }
      ] : []
    )
  })
}
