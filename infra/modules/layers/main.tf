data "archive_file" "auth_zip" {
  type        = "zip"
  source_dir  = "${path.module}/auth"
  output_path = "${path.module}/dist/auth.zip"
}

resource "aws_lambda_layer_version" "auth" {
  layer_name          = "auth"
  filename            = data.archive_file.auth_zip.output_path
  source_code_hash    = data.archive_file.auth_zip.output_base64sha256
  compatible_runtimes = ["python3.14"]
}
