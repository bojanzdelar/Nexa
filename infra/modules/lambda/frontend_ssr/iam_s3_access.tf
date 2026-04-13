resource "aws_iam_role_policy" "lambda_s3" {
  name = "nexa-frontend-snapshot-write"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:HeadObject"
        ]
        Resource = "arn:aws:s3:::${var.snapshots_bucket_name}/*"
      }
    ]
  })
}
