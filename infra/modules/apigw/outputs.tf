output "execution_arn" {
  value = aws_apigatewayv2_api.platform_api.execution_arn
}

output "hostname" {
  value = replace(
    aws_apigatewayv2_api.platform_api.api_endpoint,
    "https://",
    ""
  )
}
