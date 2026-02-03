resource "aws_lambda_permission" "apigw_invoke_hls" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hls_key.function_name
  principal     = "apigateway.amazonaws.com"
}
