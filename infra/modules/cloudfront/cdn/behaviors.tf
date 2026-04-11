locals {
  ordered_cache_behaviors = [
    {
      path_pattern               = "/movies/*"
      target_origin_id           = var.origins["video_processed"].id
      viewer_protocol_policy     = "redirect-to-https"
      allowed_methods            = ["GET", "HEAD"]
      cached_methods             = ["GET", "HEAD"]
      compress                   = false
      cache_policy_id            = data.aws_cloudfront_cache_policy.optimized.id
      trusted_key_groups         = [aws_cloudfront_key_group.media.id]
      response_headers_policy_id = aws_cloudfront_response_headers_policy.cors_with_credentials.id
    },
    {
      path_pattern               = "/shows/*"
      target_origin_id           = var.origins["video_processed"].id
      viewer_protocol_policy     = "redirect-to-https"
      allowed_methods            = ["GET", "HEAD"]
      cached_methods             = ["GET", "HEAD"]
      compress                   = false
      cache_policy_id            = data.aws_cloudfront_cache_policy.optimized.id
      trusted_key_groups         = [aws_cloudfront_key_group.media.id]
      response_headers_policy_id = aws_cloudfront_response_headers_policy.cors_with_credentials.id
    },
    {
      path_pattern               = "/placeholders/*"
      target_origin_id           = var.origins["video_processed"].id
      viewer_protocol_policy     = "redirect-to-https"
      allowed_methods            = ["GET", "HEAD"]
      cached_methods             = ["GET", "HEAD"]
      compress                   = false
      cache_policy_id            = data.aws_cloudfront_cache_policy.optimized.id
      trusted_key_groups         = [aws_cloudfront_key_group.media.id]
      response_headers_policy_id = aws_cloudfront_response_headers_policy.cors_with_credentials.id
    },
    {
      path_pattern               = "/subtitles/*"
      target_origin_id           = var.origins["content_protected"].id
      viewer_protocol_policy     = "redirect-to-https"
      allowed_methods            = ["GET", "HEAD"]
      cached_methods             = ["GET", "HEAD"]
      compress                   = true
      cache_policy_id            = data.aws_cloudfront_cache_policy.optimized.id
      trusted_key_groups         = [aws_cloudfront_key_group.media.id]
      response_headers_policy_id = aws_cloudfront_response_headers_policy.cors_with_credentials.id
    }
  ]
}
