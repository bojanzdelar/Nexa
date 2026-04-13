data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/index.js"
  output_path = "${path.module}/dist/frontend_failover_rewrite.zip"
}

resource "aws_lambda_function" "frontend_failover_rewrite" {
  function_name = "nexa-frontend-failover-rewrite"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs24.x"
  provider      = aws

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  publish = true
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.frontend_failover_rewrite.function_name}"
  provider          = aws
  retention_in_days = 30
}
