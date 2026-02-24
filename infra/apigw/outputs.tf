output "execution_arn" {
  value = aws_apigatewayv2_api.platform_api.execution_arn
}

output "target_domain_name" {
  value = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
}

output "hosted_zone_id" {
  value = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].hosted_zone_id
}

output "api_endpoints" {
  value = {
    base    = aws_apigatewayv2_api.platform_api.api_endpoint
    hls_key = "${aws_apigatewayv2_api.platform_api.api_endpoint}/hls-key"
  }
}
