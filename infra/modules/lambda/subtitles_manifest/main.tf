data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/subtitles_manifest.py"
  output_path = "${path.module}/dist/subtitles_manifest.zip"
}

data "archive_file" "pycountry_zip" {
  type        = "zip"
  source_dir  = "${path.module}/layers/pycountry"
  output_path = "${path.module}/layers/dist/pycountry.zip"
}

resource "aws_lambda_layer_version" "pycountry" {
  layer_name          = "pycountry"
  filename            = data.archive_file.pycountry_zip.output_path
  source_code_hash    = data.archive_file.pycountry_zip.output_base64sha256
  compatible_runtimes = ["python3.14"]
}

resource "aws_lambda_function" "subtitles_manifest" {
  function_name = "nexa-subtitles-manifest"
  role          = aws_iam_role.lambda_role.arn
  handler       = "subtitles_manifest.lambda_handler"
  runtime       = "python3.14"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  layers = [
    var.auth_layer_arn,
    aws_lambda_layer_version.pycountry.arn
  ]

  environment {
    variables = {
      SUBTITLES_BUCKET = var.subtitles_bucket
      USER_POOL_ISSUER = var.user_pool_issuer
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.subtitles_manifest.function_name}"
  retention_in_days = 30
}
