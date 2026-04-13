
module "frontend_assets" {
  source                   = "./secure_bucket"
  bucket_name              = "nexa-frontend-assets"
  bucket_suffix            = var.bucket_suffix
  enable_cors              = true
  cloudfront_frontend_urls = var.cloudfront_frontend_urls
}

module "frontend_snapshots" {
  source                   = "./secure_bucket"
  bucket_name              = "nexa-frontend-snapshots"
  bucket_suffix            = var.bucket_suffix
  enable_cors              = true
  cloudfront_frontend_urls = var.cloudfront_frontend_urls
}

module "content_public" {
  source                   = "./secure_bucket"
  bucket_name              = "nexa-content-public"
  bucket_suffix            = var.bucket_suffix
  enable_versioning        = true
  enable_cors              = true
  cloudfront_frontend_urls = var.cloudfront_frontend_urls
}

module "content_protected" {
  source                   = "./secure_bucket"
  bucket_name              = "nexa-content-protected"
  bucket_suffix            = var.bucket_suffix
  enable_versioning        = true
  enable_cors              = true
  cloudfront_frontend_urls = var.cloudfront_frontend_urls
}

module "video_ingest" {
  source            = "./secure_bucket"
  bucket_name       = "nexa-video-ingest"
  bucket_suffix     = var.bucket_suffix
  enable_versioning = true
}

module "video_processed" {
  source                   = "./secure_bucket"
  bucket_name              = "nexa-video-processed"
  bucket_suffix            = var.bucket_suffix
  enable_cors              = true
  cloudfront_frontend_urls = var.cloudfront_frontend_urls
}
