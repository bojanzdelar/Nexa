resource "aws_iam_role_policy" "lambda_mediaconvert" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["mediaconvert:CreateJob", "mediaconvert:DescribeEndpoints"]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_pass_mediaconvert_role" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "iam:PassRole",
      Resource = var.mediaconvert_role_arn,
      Condition = {
        StringEquals = {
          "iam:PassedToService" = "mediaconvert.amazonaws.com"
        }
      }
    }]
  })
}
