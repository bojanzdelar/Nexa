resource "aws_cloudfront_function" "allow_only_custom_domain" {
  name    = "frontend-allow-only-custom-domain"
  runtime = "cloudfront-js-2.0"
  publish = true
  code = templatefile("${path.module}/../functions/allow-only-custom-domain.js", {
    domain_name = var.domain_name
  })
}
