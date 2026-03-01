data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/subtitles_manifest.py"
  output_path = "${path.module}/dist/subtitles_manifest.zip"
}

resource "aws_lambda_layer_version" "pycountry" {
  layer_name          = "pycountry"
  filename            = "${path.module}/layers/pycountry/pycountry-layer.zip"
  source_code_hash    = filebase64sha256("${path.module}/layers/pycountry/pycountry-layer.zip")
  compatible_runtimes = ["python3.14"]
}

resource "aws_lambda_layer_version" "rsa" {
  layer_name          = "rsa"
  filename            = "${path.module}/layers/rsa/rsa-layer.zip"
  source_code_hash    = filebase64sha256("${path.module}/layers/rsa/rsa-layer.zip")
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
    aws_lambda_layer_version.pycountry.arn,
    aws_lambda_layer_version.rsa.arn
  ]

  environment {
    variables = {
      SUBTITLES_BUCKET = var.subtitles_bucket
      CLOUDFRONT_URL   = var.cloudfront_url
      PUBLIC_KEY_ID    = var.public_key_id
      PRIVATE_KEY_NAME = var.private_key_name
    }
  }
}

