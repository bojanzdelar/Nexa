module "video_assets" {
  source            = "../modules/secure_bucket"
  bucket_name       = "nexa-video-assets"
  enable_versioning = true
}

module "video_ingest" {
  source      = "../modules/secure_bucket"
  bucket_name = "nexa-video-ingest"
}

module "video_processed" {
  source      = "../modules/secure_bucket"
  bucket_name = "nexa-video-processed"
}
