module "cloudfront_frontend" {
  source = "./modules/cloudfront/frontend"

  s3_origin_domain_name = module.s3.buckets.frontend_assets.bucket_domain
  lambda_origin_domain  = module.frontend_ssr.function_url
  domain_name           = var.app_domain_name
  acm_certificate_arn   = module.acm_global.certificate_arn
  web_acl_arn           = var.enable_cf_frontend_waf ? module.waf_frontend[0].web_acl_arn : null
}

module "apigw" {
  source = "./modules/apigw"

  hls_key_lambda_invoke_arn            = module.hls_key_server.lambda_invoke_arn
  hls_playlist_token_lambda_invoke_arn = module.hls_playlist_token.lambda_invoke_arn
  hls_playlist_lambda_invoke_arn       = module.hls_playlist.lambda_invoke_arn
  subtitles_manifest_lambda_invoke_arn = module.subtitles_manifest.lambda_invoke_arn
  cloudfront_frontend_url              = local.cloudfront_frontend_url
  domain_name                          = var.app_domain_name
  acm_certificate_arn                  = module.acm_regional.certificate_arn
}

module "cloudfront_cdn" {
  source = "./modules/cloudfront/cdn"

  origins = {
    for k, v in local.cloudfront_cdn_origins :
    k => {
      id          = v.bucket_name
      domain_name = v.bucket_domain
    }
  }

  public_key_value        = module.ssm.cloudfront_public_key_value
  domain_name             = var.app_domain_name
  cloudfront_frontend_url = local.cloudfront_frontend_url
  acm_certificate_arn     = module.acm_global.certificate_arn
  web_acl_arn             = var.enable_cf_cdn_waf ? module.waf_cdn[0].web_acl_arn : null
}

module "waf_cdn" {
  source = "./modules/waf"

  count = var.enable_cf_cdn_waf ? 1 : 0

  name = "nexa-cf-cdn-waf"

  providers = {
    aws = aws.us_east_1
  }
}

module "waf_frontend" {
  source = "./modules/waf"

  count = var.enable_cf_frontend_waf ? 1 : 0

  name = "nexa-cf-frontend-waf"

  providers = {
    aws = aws.us_east_1
  }
}

module "ecr" {
  source = "./modules/ecr"

  services = local.services
}

module "ecs" {
  source = "./modules/ecs"

  services = local.services

  container_port        = var.container_port
  enable_alb            = var.enable_alb
  target_group_arns     = var.enable_alb ? module.alb[0].target_group_arns : {}
  desired_count         = var.ecs_desired_count
  enable_opensearch     = var.enable_opensearch
  opensearch_domain_arn = try(module.opensearch[0].arn, null)
}

module "alb" {
  source = "./modules/alb"

  count = var.enable_alb ? 1 : 0

  services       = local.services
  container_port = var.container_port

  acm_certificate_arn = module.acm_regional.certificate_arn
}

module "catalog" {
  source = "./modules/dynamodb/catalog"
}

module "users" {
  source = "./modules/dynamodb/users"
}

module "s3" {
  source = "./modules/s3"

  bucket_suffix           = var.s3_bucket_suffix
  cloudfront_frontend_url = local.cloudfront_frontend_url
}

module "frontend_ssr" {
  source = "./modules/lambda/frontend_ssr"

  cf_frontend_arn         = module.cloudfront_frontend.distribution_arn
  provisioned_concurrency = var.ssr_provisioned_concurrency
}

module "transcode_dispatcher" {
  source = "./modules/lambda/transcode_dispatcher"

  mediaconvert_role_arn = module.mediaconvert.iam_role_arn
  hls_key_api_base      = module.apigw.api_endpoints.hls_key
  output_bucket_name    = module.s3.buckets.video_processed.bucket_name
}

module "hls_key_server" {
  source = "./modules/lambda/hls_key_server"

  apigw_execution_arn = module.apigw.execution_arn
  auth_layer_arn      = module.layers.auth_arn
  signing_secret_name = module.ssm.hls_segment_signing_secret_name
}

module "hls_playlist_token" {
  source = "./modules/lambda/hls_playlist_token"

  apigw_execution_arn = module.apigw.execution_arn
  auth_layer_arn      = module.layers.auth_arn
  signing_secret_name = module.ssm.hls_playlist_signing_secret_name
  user_pool_issuer    = module.cognito.user_pool_issuer
}

module "hls_playlist" {
  source = "./modules/lambda/hls_playlist"

  apigw_execution_arn          = module.apigw.execution_arn
  auth_layer_arn               = module.layers.auth_arn
  key_endpoint                 = module.apigw.api_endpoints.hls_key
  playlist_bucket              = module.s3.buckets.video_processed.bucket_name
  cloudfront_domain_name       = module.cloudfront_cdn.distribution_https_url
  public_key_id                = module.cloudfront_cdn.media_public_key_id
  private_key_name             = module.ssm.cloudfront_private_key_name
  playlist_signing_secret_name = module.ssm.hls_playlist_signing_secret_name
  segment_signing_secret_name  = module.ssm.hls_segment_signing_secret_name
}

module "subtitles_manifest" {
  source = "./modules/lambda/subtitles_manifest"

  apigw_execution_arn = module.apigw.execution_arn
  auth_layer_arn      = module.layers.auth_arn
  subtitles_bucket    = module.s3.buckets.content_protected.bucket_name
  user_pool_issuer    = module.cognito.user_pool_issuer
}

module "layers" {
  source = "./modules/layers"
}

module "mediaconvert" {
  source = "./modules/mediaconvert"

  ingest_bucket_arn    = module.s3.buckets.video_ingest.bucket_arn
  processed_bucket_arn = module.s3.buckets.video_processed.bucket_arn
}

module "cognito" {
  source = "./modules/cognito"

  email_address  = var.notification_email
  ses_source_arn = module.ses.domain_identity_arn
}

module "ses" {
  source = "./modules/ses"

  domain_identity = var.email_domain_name
}

module "ssm" {
  source = "./modules/ssm"
}

module "route53" {
  source = "./modules/route53"

  domain_name                = var.root_domain_name
  enable_alb                 = var.enable_alb
  alb_dns_name               = try(module.alb[0].dns_name, null)
  alb_zone_id                = try(module.alb[0].zone_id, null)
  apigw_domain_name          = module.apigw.target_domain_name
  apigw_hosted_zone_id       = module.apigw.hosted_zone_id
  cf_frontend_domain_name    = module.cloudfront_frontend.distribution_domain_name
  cf_frontend_hosted_zone_id = module.cloudfront_frontend.distribution_hosted_zone_id
  cf_cdn_domain_name         = module.cloudfront_cdn.distribution_domain_name
  cf_cdn_hosted_zone_id      = module.cloudfront_cdn.distribution_hosted_zone_id
  ses_region                 = var.aws_region
  ses_domain_dkim            = module.ses.domain_dkim
}

module "acm_global" {
  source = "./modules/acm"

  providers = {
    aws = aws.us_east_1
  }

  domain_name = var.app_domain_name
  subject_alternative_names = [
    "*.${var.app_domain_name}"
  ]
  route53_zone_id = module.route53.zone_id
}

module "acm_regional" {
  source = "./modules/acm"

  domain_name = var.app_domain_name
  subject_alternative_names = [
    "*.${var.app_domain_name}"
  ]
  route53_zone_id = module.route53.zone_id
}

module "opensearch" {
  source = "./modules/opensearch"

  count = var.enable_opensearch ? 1 : 0

  allowed_role_arns = [module.ecs.task_role_arns["search-service"]]
}

module "integrations" {
  source = "./integrations"

  cloudfront_origins = local.cloudfront_origins
  video_ingest       = module.s3.buckets.video_ingest
  transcode_lambda = {
    name = module.transcode_dispatcher.lambda_name
    arn  = module.transcode_dispatcher.lambda_arn
  }
}
