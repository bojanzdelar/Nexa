resource "aws_lambda_permission" "frontend_ssr_url" {
  statement_id           = "AllowPublicAccess"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.frontend_ssr.function_name
  principal              = "cloudfront.amazonaws.com"
  source_arn             = var.cf_frontend_arn
  function_url_auth_type = "NONE"
}
