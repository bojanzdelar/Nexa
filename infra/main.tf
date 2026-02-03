module "apigw" {
  source = "./apigw"

  cognito_client_id        = var.cognito_client_id
  cognito_user_pool_issuer = var.cognito_user_pool_issuer

  hls_lambda_invoke_arn = module.hls_key_server.lambda_invoke_arn
}

module "s3" {
  source = "./s3"
}

module "transcode_dispatcher" {
  source = "./lambda/transcode_dispatcher"

  mediaconvert_role_arn = module.mediaconvert.iam_role_arn
  hls_key_api_base      = module.apigw.api_endpoints.hls_key
  output_bucket_name    = module.s3.video_processed_bucket_name
}

module "hls_key_server" {
  source = "./lambda/hls_key_server"
}

module "mediaconvert" {
  source = "./mediaconvert"

  ingest_bucket_arn    = module.s3.video_ingest_bucket_arn
  processed_bucket_arn = module.s3.video_processed_bucket_arn
}
