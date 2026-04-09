resource "aws_lambda_permission" "frontend_ssr_url" {
  statement_id           = "AllowCloudFrontOnly"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.frontend_ssr.function_name
  qualifier              = aws_lambda_alias.frontend_ssr_live.name
  principal              = "cloudfront.amazonaws.com"
  source_arn             = var.cf_frontend_arn
  function_url_auth_type = "AWS_IAM"
}
