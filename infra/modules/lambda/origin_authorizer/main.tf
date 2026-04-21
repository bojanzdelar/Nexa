
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/origin_authorizer.py"
  output_path = "${path.module}/dist/origin_authorizer.py"
}

resource "aws_lambda_function" "origin_authorizer" {
  function_name = "nexa-origin-authorizer"
  role          = aws_iam_role.lambda_role.arn
  handler       = "origin_authorizer.lambda_handler"
  runtime       = "python3.14"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      ORIGIN_SECRET = var.origin_secret
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.origin_authorizer.function_name}"
  retention_in_days = 30
}


