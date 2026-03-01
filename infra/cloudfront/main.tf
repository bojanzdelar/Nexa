resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  price_class         = "PriceClass_All"
  is_ipv6_enabled     = true
  http_version        = "http2"
  wait_for_deployment = true
  web_acl_id          = var.web_acl_arn

  aliases = [
    "cdn.${var.domain_name}"
  ]

  tags = {
    Name = "nexa-cdn-main"
  }

  dynamic "origin" {
    for_each = var.origins

    content {
      domain_name              = origin.value.domain_name
      origin_id                = origin.value.id
      origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    }
  }

  default_cache_behavior {
    target_origin_id       = var.origins["content_public"].id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    compress        = true
    cache_policy_id = data.aws_cloudfront_cache_policy.optimized.id
  }

  dynamic "ordered_cache_behavior" {
    for_each = local.ordered_cache_behaviors
    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      compress               = ordered_cache_behavior.value.compress
      cache_policy_id        = ordered_cache_behavior.value.cache_policy_id
      trusted_key_groups = lookup(
        ordered_cache_behavior.value,
        "trusted_key_groups",
        null
      )
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
