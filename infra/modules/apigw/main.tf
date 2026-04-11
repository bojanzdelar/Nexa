resource "aws_apigatewayv2_api" "platform_api" {
  name          = "nexa-platform-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins     = [var.cloudfront_frontend_url]
    allow_methods     = ["GET", "HEAD", "POST", "OPTIONS"]
    allow_headers     = ["Authorization", "Content-Type"]
    allow_credentials = true
  }
}

resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = "playback.${var.domain_name}"

  domain_name_configuration {
    certificate_arn = var.acm_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.platform_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api_mapping" "api" {
  api_id      = aws_apigatewayv2_api.platform_api.id
  domain_name = aws_apigatewayv2_domain_name.api.id
  stage       = aws_apigatewayv2_stage.default.id
}
