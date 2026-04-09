resource "aws_lambda_permission" "allow_apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hls_playlist.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apigw_execution_arn}/*/GET/playlist/*"
}
