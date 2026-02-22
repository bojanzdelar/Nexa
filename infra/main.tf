module "apigw" {
  source = "./apigw"

  cognito_client_id        = module.cognito.client_id
  cognito_user_pool_issuer = module.cognito.user_pool_issuer

  hls_key_lambda_invoke_arn      = module.hls_key_server.lambda_invoke_arn
  hls_playlist_lambda_invoke_arn = module.hls_playlist.lambda_invoke_arn
}

module "cloudfront" {
  source = "./cloudfront"

  web_acl_arn = module.waf.web_acl_arn

  origins = {
    content_public = {
      id          = module.s3.content_public_bucket_name
      domain_name = module.s3.content_public_bucket_regional_domain_name
    }
    content_protected = {
      id          = module.s3.content_protected_bucket_name
      domain_name = module.s3.content_protected_bucket_regional_domain_name
    }
    video_processed = {
      id          = module.s3.video_processed_bucket_name
      domain_name = module.s3.video_processed_bucket_regional_domain_name
    }
  }
}

module "waf" {
  source = "./waf"

  providers = {
    aws = aws.us_east_1
  }
}

module "catalog" {
  source = "./dynamodb/catalog"
}

module "users" {
  source = "./dynamodb/users"
}

module "s3" {
  source = "./s3"

  cloudfront_distribution_arn = module.cloudfront.distribution_arn
}

module "transcode_dispatcher" {
  source = "./lambda/transcode_dispatcher"

  mediaconvert_role_arn = module.mediaconvert.iam_role_arn
  hls_key_api_base      = module.apigw.api_endpoints.hls_key
  output_bucket_name    = module.s3.video_processed_bucket_name
}

module "hls_key_server" {
  source = "./lambda/hls_key_server"

  apigw_execution_arn = module.apigw.execution_arn
  signing_secret      = var.hls_signing_secret
}


module "hls_playlist" {
  source = "./lambda/hls_playlist"

  apigw_execution_arn    = module.apigw.execution_arn
  key_endpoint           = module.apigw.api_endpoints.hls_key
  playlist_bucket        = module.s3.video_processed_bucket_name
  cloudfront_domain_name = module.cloudfront.distribution_domain_name
  signing_secret         = var.hls_signing_secret
}

module "mediaconvert" {
  source = "./mediaconvert"

  ingest_bucket_arn    = module.s3.video_ingest_bucket_arn
  processed_bucket_arn = module.s3.video_processed_bucket_arn
}

module "cognito" {
  source = "./cognito"

  ses_source_arn = module.ses.domain_identity_arn
}

module "ses" {
  source = "./ses"
}

module "opensearch" {
  source = "./opensearch"

  count = var.enable_opensearch ? 1 : 0
}
