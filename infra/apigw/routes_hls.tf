resource "aws_apigatewayv2_integration" "hls_key_integration" {
  api_id                 = aws_apigatewayv2_api.platform_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.hls_key_lambda_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "hls_key_route" {
  api_id    = aws_apigatewayv2_api.platform_api.id
  route_key = "GET /hls-key/{type}/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.hls_key_integration.id}"
}

resource "aws_apigatewayv2_integration" "hls_playlist_integration" {
  api_id                 = aws_apigatewayv2_api.platform_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.hls_playlist_lambda_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "playlist_route" {
  api_id    = aws_apigatewayv2_api.platform_api.id
  route_key = "GET /playlist/{type}/{id}/{filename}"
  target    = "integrations/${aws_apigatewayv2_integration.hls_playlist_integration.id}"
}
