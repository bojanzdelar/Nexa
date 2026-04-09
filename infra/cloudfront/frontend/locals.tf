locals {
  s3_behaviors = [
    {
      path  = "/_nuxt/*"
      cache = data.aws_cloudfront_cache_policy.optimized.id
    },
    {
      path  = "/images/*"
      cache = data.aws_cloudfront_cache_policy.optimized.id
    },
    {
      path  = "/workbox-*"
      cache = data.aws_cloudfront_cache_policy.optimized.id
    },
    {
      path  = "/robots.txt"
      cache = data.aws_cloudfront_cache_policy.optimized.id
    },
    {
      path  = "/sw.js"
      cache = data.aws_cloudfront_cache_policy.no_cache.id
    },
    {
      path  = "/manifest.webmanifest"
      cache = data.aws_cloudfront_cache_policy.no_cache.id
    }
  ]
}
