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
      HLS_KEY_API_BASE  = var.hls_key_api_base
      MEDIACONVERT_ROLE = var.mediaconvert_role_arn
      OUTPUT_BUCKET     = var.output_bucket_name
    }
  }
}

