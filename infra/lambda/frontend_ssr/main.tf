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
}

resource "aws_lambda_function_url" "frontend_ssr" {
  function_name      = aws_lambda_function.frontend_ssr.function_name
  authorization_type = "NONE"
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.frontend_ssr.function_name}"
  retention_in_days = 30
}
