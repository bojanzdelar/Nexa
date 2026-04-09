
module "frontend_assets" {
  source        = "./secure_bucket"
  bucket_name   = "nexa-frontend-assets"
  bucket_prefix = var.bucket_prefix
  enable_cors   = true
}

module "content_public" {
  source            = "./secure_bucket"
  bucket_name       = "nexa-content-public"
  bucket_prefix     = var.bucket_prefix
  enable_versioning = true
  enable_cors       = true
}

module "content_protected" {
  source            = "./secure_bucket"
  bucket_name       = "nexa-content-protected"
  bucket_prefix     = var.bucket_prefix
  enable_versioning = true
  enable_cors       = true
}

module "video_ingest" {
  source            = "./secure_bucket"
  bucket_name       = "nexa-video-ingest"
  bucket_prefix     = var.bucket_prefix
  enable_versioning = true
}

module "video_processed" {
  source        = "./secure_bucket"
  bucket_name   = "nexa-video-processed"
  bucket_prefix = var.bucket_prefix
  enable_cors   = true
}
