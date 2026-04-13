locals {
  bucket_modules = {
    frontend_assets    = module.frontend_assets
    frontend_snapshots = module.frontend_snapshots
    content_public     = module.content_public
    content_protected  = module.content_protected
    video_ingest       = module.video_ingest
    video_processed    = module.video_processed
  }
}
