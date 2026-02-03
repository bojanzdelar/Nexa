output "api_endpoints" {
  value = {
    base    = aws_apigatewayv2_api.platform_api.api_endpoint
    hls_key = "${aws_apigatewayv2_api.platform_api.api_endpoint}/hls-key"
  }
}
