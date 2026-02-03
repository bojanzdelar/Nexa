resource "aws_apigatewayv2_integration" "hls_lambda_integration" {
  api_id                 = aws_apigatewayv2_api.platform_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.hls_lambda_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "hls_key_route" {
  api_id    = aws_apigatewayv2_api.platform_api.id
  route_key = "GET /hls-key/{video_id}"
  target    = "integrations/${aws_apigatewayv2_integration.hls_lambda_integration.id}"

  authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
  authorization_type = "JWT"
}

