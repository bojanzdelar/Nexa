locals {
  bucket_modules = {
    frontend_assets   = module.frontend_assets
    content_public    = module.content_public
    content_protected = module.content_protected
    video_ingest      = module.video_ingest
    video_processed   = module.video_processed
  }
}
