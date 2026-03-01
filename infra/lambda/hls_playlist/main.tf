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

  environment {
    variables = {
      PLAYLIST_BUCKET        = var.playlist_bucket
      KEY_ENDPOINT           = var.key_endpoint
      CLOUDFRONT_DOMAIN_NAME = var.cloudfront_domain_name
      SIGNING_SECRET_NAME    = var.signing_secret_name
    }
  }
}
