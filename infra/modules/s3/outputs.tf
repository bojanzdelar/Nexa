output "buckets" {
  value = {
    for name, mod in local.bucket_modules :
    name => {
      bucket_name   = mod.bucket_name
      bucket_arn    = mod.bucket_arn
      bucket_domain = mod.bucket_domain
    }
  }
}
