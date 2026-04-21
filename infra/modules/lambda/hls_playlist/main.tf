data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/hls_playlist.py"
  output_path = "${path.module}/dist/hls_playlist.zip"
}

resource "aws_lambda_function" "hls_playlist" {
  function_name = "nexa-hls-playlist"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hls_playlist.lambda_handler"
  runtime       = "python3.14"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  layers           = [var.auth_layer_arn]

  environment {
    variables = {
      PLAYLIST_BUCKET                 = var.playlist_bucket
      CLOUDFRONT_FRONTEND_DOMAIN_NAME = var.cloudfront_frontend_domain_name
      CLOUDFRONT_CDN_DOMAIN_NAME      = var.cloudfront_cdn_domain_name
      PUBLIC_KEY_ID                   = var.public_key_id
      PRIVATE_KEY_NAME                = var.private_key_name
      PLAYLIST_SIGNING_SECRET_NAME    = var.playlist_signing_secret_name
      SEGMENT_SIGNING_SECRET_NAME     = var.segment_signing_secret_name
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.hls_playlist.function_name}"
  retention_in_days = 30
}
