output "content_public_bucket_name" {
  value = module.content_public.bucket_name
}

output "content_public_bucket_regional_domain_name" {
  value = module.content_public.bucket_regional_domain_name
}

output "content_protected_bucket_name" {
  value = module.content_protected.bucket_name
}

output "content_protected_bucket_regional_domain_name" {
  value = module.content_protected.bucket_regional_domain_name
}

output "video_ingest_bucket_name" {
  value = module.video_ingest.bucket_name
}

output "video_ingest_bucket_arn" {
  value = module.video_ingest.bucket_arn
}

output "video_processed_bucket_name" {
  value = module.video_processed.bucket_name
}

output "video_processed_bucket_regional_domain_name" {
  value = module.video_processed.bucket_regional_domain_name
}

output "video_processed_bucket_arn" {
  value = module.video_processed.bucket_arn
}

