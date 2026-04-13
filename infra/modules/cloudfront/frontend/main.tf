resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  price_class         = "PriceClass_All"
  is_ipv6_enabled     = true
  http_version        = "http2"
  wait_for_deployment = true
  web_acl_id          = var.web_acl_arn

  aliases = [
    var.domain_name
  ]

  tags = {
    Name = "nexa-frontend"
  }

  origin {
    domain_name              = var.s3_assets_origin_domain_name
    origin_id                = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
  }

  origin {
    domain_name              = trimsuffix(replace(var.lambda_origin_domain, "https://", ""), "/")
    origin_id                = "lambda-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.lambda.id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    domain_name              = var.s3_snapshots_origin_domain_name
    origin_id                = "snapshot-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
  }

  origin_group {
    origin_id = "lambda-failover-group"

    failover_criteria {
      status_codes = [500, 502, 503, 504]
    }

    member {
      origin_id = "lambda-origin"
    }

    member {
      origin_id = "snapshot-origin"
    }
  }

  default_cache_behavior {
    target_origin_id       = "lambda-failover-group"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    compress                 = true
    cache_policy_id          = data.aws_cloudfront_cache_policy.no_cache.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host_header.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.allow_only_custom_domain.arn
    }

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = var.failover_rewrite_lambda_arn
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = local.s3_behaviors

    content {
      path_pattern           = ordered_cache_behavior.value.path
      target_origin_id       = "s3-origin"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]

      compress        = true
      cache_policy_id = ordered_cache_behavior.value.cache

      function_association {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.allow_only_custom_domain.arn
      }
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
