module "apigw" {
  source = "./apigw"

  cognito_client_id        = module.cognito.client_id
  cognito_user_pool_issuer = module.cognito.user_pool_issuer

  hls_key_lambda_invoke_arn            = module.hls_key_server.lambda_invoke_arn
  hls_playlist_lambda_invoke_arn       = module.hls_playlist.lambda_invoke_arn
  subtitles_manifest_lambda_invoke_arn = module.subtitles_manifest.lambda_invoke_arn

  domain_name         = var.app_domain_name
  acm_certificate_arn = module.acm_regional.certificate_arn
}

module "cloudfront" {
  source = "./cloudfront"

  web_acl_arn      = module.waf.web_acl_arn
  public_key_value = module.ssm.cloudfront_public_key_value

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

  domain_name         = var.app_domain_name
  acm_certificate_arn = module.acm_global.certificate_arn
}

module "waf" {
  source = "./waf"

  providers = {
    aws = aws.us_east_1
  }
}

module "ecr" {
  source = "./ecr"

  services = local.services
}

module "ecs" {
  source = "./ecs"

  services = local.services

  container_port        = var.container_port
  enable_alb            = var.enable_alb
  target_group_arns     = var.enable_alb ? module.alb[0].target_group_arns : {}
  desired_count         = var.ecs_desired_count
  enable_opensearch     = var.enable_opensearch
  opensearch_domain_arn = try(module.opensearch[0].arn, null)
}

module "alb" {
  source = "./alb"

  count = var.enable_alb ? 1 : 0

  services       = local.services
  container_port = var.container_port

  acm_certificate_arn = module.acm_regional.certificate_arn
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
  signing_secret_name = module.ssm.hls_signing_secret_name
}


module "hls_playlist" {
  source = "./lambda/hls_playlist"

  apigw_execution_arn    = module.apigw.execution_arn
  key_endpoint           = module.apigw.api_endpoints.hls_key
  playlist_bucket        = module.s3.video_processed_bucket_name
  cloudfront_domain_name = module.cloudfront.distribution_https_url
  signing_secret_name    = module.ssm.hls_signing_secret_name
}

module "subtitles_manifest" {
  source = "./lambda/subtitles_manifest"

  apigw_execution_arn = module.apigw.execution_arn
  subtitles_bucket    = module.s3.content_protected_bucket_name
  cloudfront_url      = module.cloudfront.distribution_https_url
  public_key_id       = module.cloudfront.media_public_key_id
  private_key_name    = module.ssm.cloudfront_private_key_name
}

module "mediaconvert" {
  source = "./mediaconvert"

  ingest_bucket_arn    = module.s3.video_ingest_bucket_arn
  processed_bucket_arn = module.s3.video_processed_bucket_arn
}

module "cognito" {
  source = "./cognito"

  email_address  = var.notification_email
  ses_source_arn = module.ses.domain_identity_arn
}

module "ses" {
  source = "./ses"

  domain_identity = var.email_domain_name
}

module "ssm" {
  source = "./ssm"
}

module "route53" {
  source = "./route53"

  domain_name               = var.root_domain_name
  enable_alb                = var.enable_alb
  alb_dns_name              = try(module.alb[0].dns_name, null)
  alb_zone_id               = try(module.alb[0].zone_id, null)
  apigw_domain_name         = module.apigw.target_domain_name
  apigw_hosted_zone_id      = module.apigw.hosted_zone_id
  cloudfront_domain_name    = module.cloudfront.distribution_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.distribution_hosted_zone_id
  ses_region                = var.aws_region
  ses_domain_dkim           = module.ses.domain_dkim
  acm_domain_validation_options = concat(
    tolist(module.acm_global.domain_validation_options),
    tolist(module.acm_regional.domain_validation_options)
  )
}

module "acm_global" {
  source = "./acm"

  providers = {
    aws = aws.us_east_1
  }

  domain_name = var.app_domain_name
  subject_alternative_names = [
    "*.${var.app_domain_name}"
  ]
}

module "acm_regional" {
  source = "./acm"

  domain_name = var.app_domain_name
  subject_alternative_names = [
    "*.${var.app_domain_name}"
  ]
}

module "opensearch" {
  source = "./opensearch"

  count = var.enable_opensearch ? 1 : 0

  allowed_role_arns = [module.ecs.task_role_arns["search-service"]]
}
