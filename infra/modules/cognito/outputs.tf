output "user_pool_issuer" {
  value = "https://cognito-idp.${data.aws_region.current.id}.amazonaws.com/${aws_cognito_user_pool.this.id}"
}

output "client_id" {
  value = aws_cognito_user_pool_client.app.id
}

