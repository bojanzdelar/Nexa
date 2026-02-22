locals {
  ordered_cache_behaviors = [
    {
      path_pattern           = "/movies/*"
      target_origin_id       = var.origins["video_processed"].id
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      compress               = false
      cache_policy_id        = data.aws_cloudfront_cache_policy.optimized.id
      trusted_signers        = []
    },
    {
      path_pattern           = "/shows/*"
      target_origin_id       = var.origins["video_processed"].id
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      compress               = false
      cache_policy_id        = data.aws_cloudfront_cache_policy.optimized.id
      trusted_signers        = []
    },
    {
      path_pattern           = "/placeholders/*"
      target_origin_id       = var.origins["video_processed"].id
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      compress               = false
      cache_policy_id        = data.aws_cloudfront_cache_policy.optimized.id
      trusted_signers        = []
    },
    {
      path_pattern           = "/subtitles/*"
      target_origin_id       = var.origins["content_protected"].id
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      compress               = true
      cache_policy_id        = data.aws_cloudfront_cache_policy.optimized.id
      trusted_signers        = []
    }
  ]
}
