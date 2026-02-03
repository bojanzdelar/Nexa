resource "aws_apigatewayv2_authorizer" "cognito_auth" {
  api_id          = aws_apigatewayv2_api.platform_api.id
  name            = "cognito-authorizer"
  authorizer_type = "JWT"

  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [var.cognito_client_id]
    issuer   = var.cognito_user_pool_issuer
  }
}
