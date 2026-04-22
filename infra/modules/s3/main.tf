
module "frontend_assets" {
  source        = "./secure_bucket"
  bucket_name   = "nexa-frontend-assets"
  bucket_suffix = var.bucket_suffix
}

module "frontend_snapshots" {
  source        = "./secure_bucket"
  bucket_name   = "nexa-frontend-snapshots"
  bucket_suffix = var.bucket_suffix
}

module "content_public" {
  source            = "./secure_bucket"
  bucket_name       = "nexa-content-public"
  bucket_suffix     = var.bucket_suffix
  enable_versioning = true
}

module "content_protected" {
  source            = "./secure_bucket"
  bucket_name       = "nexa-content-protected"
  bucket_suffix     = var.bucket_suffix
  enable_versioning = true
}

module "video_ingest" {
  source            = "./secure_bucket"
  bucket_name       = "nexa-video-ingest"
  bucket_suffix     = var.bucket_suffix
  enable_versioning = true
}

module "video_processed" {
  source        = "./secure_bucket"
  bucket_name   = "nexa-video-processed"
  bucket_suffix = var.bucket_suffix
}
