output "distribution_arn" {
  value = aws_cloudfront_distribution.this.arn
}

output "distribution_domain_name" {
  value = "https://${aws_cloudfront_distribution.this.domain_name}"
}
