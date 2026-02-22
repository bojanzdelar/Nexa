resource "aws_apigatewayv2_api" "platform_api" {
  name          = "nexa-platform-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "OPTIONS"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.platform_api.id
  name        = "$default"
  auto_deploy = true
}
