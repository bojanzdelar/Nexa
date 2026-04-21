output "lambda_invoke_arn" {
  value = aws_lambda_function.origin_authorizer.invoke_arn
}
