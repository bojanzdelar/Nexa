output "lambda_name" {
  value = aws_lambda_function.transcode.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.transcode.arn
}
