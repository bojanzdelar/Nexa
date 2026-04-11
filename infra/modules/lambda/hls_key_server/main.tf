data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/hls_key_server.py"
  output_path = "${path.module}/dist/hls_key_server.zip"
}

resource "aws_lambda_function" "hls_key" {
  function_name = "nexa-hls-key-server"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hls_key_server.lambda_handler"
  runtime       = "python3.14"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  layers           = [var.auth_layer_arn]

  environment {
    variables = {
      SIGNING_SECRET_NAME = var.signing_secret_name
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.hls_key.function_name}"
  retention_in_days = 30
}
