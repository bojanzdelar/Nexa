resource "aws_lambda_function" "hls_key" {
  function_name = "nexa-hls-key-server"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hls_key_server.lambda_handler"
  runtime       = "python3.14"

  source_code_hash = filebase64sha256("${path.module}/dist/hls_key_server.zip")
  filename         = "${path.module}/dist/hls_key_server.zip"
}
