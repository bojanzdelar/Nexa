output "distribution_arn" {
  value = aws_cloudfront_distribution.this.arn
}

output "distribution_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "distribution_https_url" {
  value = "https://cdn.${var.domain_name}"
}

output "distribution_hosted_zone_id" {
  value = aws_cloudfront_distribution.this.hosted_zone_id
}

output "media_public_key_id" {
  value = aws_cloudfront_public_key.media.id
}
