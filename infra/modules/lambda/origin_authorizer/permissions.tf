resource "aws_lambda_permission" "apigw_authorizer" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.origin_authorizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apigw_execution_arn}/*"
}
