data "archive_file" "bootstrap" {
  type        = "zip"
  source_file = "${path.module}/index.js"
  output_path = "${path.module}/dist/bootstrap.zip"
}

resource "aws_lambda_function" "frontend_ssr" {
  function_name = "nexa-frontend-ssr"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "nodejs24.x"

  filename         = data.archive_file.bootstrap.output_path
  source_code_hash = data.archive_file.bootstrap.output_base64sha256

  timeout     = 20
  memory_size = 1024
}

resource "aws_lambda_alias" "frontend_ssr_live" {
  name             = "live"
  function_name    = aws_lambda_function.frontend_ssr.function_name
  function_version = aws_lambda_function.frontend_ssr.version
}

resource "aws_lambda_provisioned_concurrency_config" "frontend" {
  count = var.provisioned_concurrency > 0 ? 1 : 0

  function_name                     = aws_lambda_function.frontend_ssr.function_name
  qualifier                         = aws_lambda_alias.frontend_ssr_live.name
  provisioned_concurrent_executions = var.provisioned_concurrency
}

resource "aws_lambda_function_url" "frontend_ssr" {
  function_name      = aws_lambda_function.frontend_ssr.function_name
  qualifier          = aws_lambda_alias.frontend_ssr_live.name
  authorization_type = "AWS_IAM"
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.frontend_ssr.function_name}"
  retention_in_days = 30
}
