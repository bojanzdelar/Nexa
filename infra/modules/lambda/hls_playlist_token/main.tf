data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/hls_playlist_token.py"
  output_path = "${path.module}/dist/hls_playlist_token.zip"
}

resource "aws_lambda_function" "hls_playlist_token" {
  function_name = "nexa-hls-playlist-token"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hls_playlist_token.lambda_handler"
  runtime       = "python3.14"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  layers           = [var.auth_layer_arn]

  environment {
    variables = {
      SIGNING_SECRET_NAME = var.signing_secret_name
      USER_POOL_ISSUER    = var.user_pool_issuer
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.hls_playlist_token.function_name}"
  retention_in_days = 30
}
