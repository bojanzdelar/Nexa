resource "aws_apigatewayv2_integration" "subtitles_manifest_integration" {
  api_id                 = aws_apigatewayv2_api.platform_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.subtitles_manifest_lambda_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "subtitles_manifest_route" {
  api_id    = aws_apigatewayv2_api.platform_api.id
  route_key = "GET /subtitles/{type}/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.subtitles_manifest_integration.id}"
}
