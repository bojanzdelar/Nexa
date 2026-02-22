module "content_public" {
  source                      = "../modules/secure_bucket"
  bucket_name                 = "nexa-content-public"
  enable_versioning           = true
  enable_cors                 = true
  allow_cloudfront_access     = true
  cloudfront_distribution_arn = var.cloudfront_distribution_arn
}

module "content_protected" {
  source                      = "../modules/secure_bucket"
  bucket_name                 = "nexa-content-protected"
  enable_versioning           = true
  enable_cors                 = true
  allow_cloudfront_access     = true
  cloudfront_distribution_arn = var.cloudfront_distribution_arn
}

module "video_ingest" {
  source            = "../modules/secure_bucket"
  bucket_name       = "nexa-video-ingest"
  enable_versioning = true
}

module "video_processed" {
  source                      = "../modules/secure_bucket"
  bucket_name                 = "nexa-video-processed"
  enable_cors                 = true
  allow_cloudfront_access     = true
  cloudfront_distribution_arn = var.cloudfront_distribution_arn
}
