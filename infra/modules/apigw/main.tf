resource "aws_apigatewayv2_api" "platform_api" {
  name          = "nexa-platform-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins     = var.cloudfront_frontend_urls
    allow_methods     = ["GET", "HEAD", "POST", "OPTIONS"]
    allow_headers     = ["Authorization", "Content-Type"]
    allow_credentials = true
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.platform_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_authorizer" "origin" {
  name = "nexa-origin-authorizer"

  api_id = aws_apigatewayv2_api.platform_api.id

  authorizer_type = "REQUEST"
  authorizer_uri  = var.origin_authorizer_lambda_invoke_arn

  identity_sources = [
    "$request.header.X-Origin-Secret"
  ]

  authorizer_payload_format_version = "2.0"
  enable_simple_responses           = true
}
