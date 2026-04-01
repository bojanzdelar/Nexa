resource "aws_ecr_repository" "services" {
  for_each = toset(var.services)

  name = "nexa-${each.value}"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

resource "aws_ecr_lifecycle_policy" "services" {
  for_each   = aws_ecr_repository.services
  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1

        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["sha-"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }

        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2

        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}
