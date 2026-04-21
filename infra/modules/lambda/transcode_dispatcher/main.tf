data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/transcode_dispatcher.py"
  output_path = "${path.module}/dist/transcode_dispatcher.zip"
}

resource "aws_lambda_function" "transcode" {
  function_name = "nexa-transcode-dispatcher"
  role          = aws_iam_role.lambda_role.arn
  handler       = "transcode_dispatcher.lambda_handler"
  runtime       = "python3.14"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      CLOUDFRONT_DOMAIN_NAME = var.cloudfront_domain_name
      MEDIACONVERT_ROLE      = var.mediaconvert_role_arn
      OUTPUT_BUCKET          = var.output_bucket_name
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.transcode.function_name}"
  retention_in_days = 30
}
