resource "aws_lambda_function" "transcode" {
  function_name = "nexa-transcode-dispatcher"
  role          = aws_iam_role.lambda_role.arn
  handler       = "transcode_dispatcher.lambda_handler"
  runtime       = "python3.14"

  source_code_hash = filebase64sha256("${path.module}/dist/transcode_dispatcher.zip")
  filename         = "${path.module}/dist/transcode_dispatcher.zip"

  environment {
    variables = {
      HLS_KEY_API_BASE  = var.hls_key_api_base
      MEDIACONVERT_ROLE = var.mediaconvert_role_arn
      OUTPUT_BUCKET     = var.output_bucket_name
    }
  }
}

