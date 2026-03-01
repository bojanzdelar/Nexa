resource "aws_iam_role_policy" "subtitles_lambda_ssm" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow"
      Action   = ["ssm:GetParameter"]
      Resource = "arn:aws:ssm:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:parameter/nexa/internal/cloudfront/media_private_key"
    }]
  })
}

resource "aws_iam_role_policy" "subtitles_lambda_kms" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow"
      Action   = ["kms:Decrypt"]
      Resource = data.aws_kms_key.ssm.arn
    }]
  })
}
