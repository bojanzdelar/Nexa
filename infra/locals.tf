locals {
  services = {
    catalog-service = {
      paths           = ["/titles/*", "/tv/*", "/movies/*"]
      dynamodb_tables = [module.catalog.table_name]
      env = {
        DYNAMODB_CATALOG_TABLE = module.catalog.table_name
      }
    }

    search-service = {
      paths           = ["/search", "/search/*"]
      dynamodb_tables = [module.catalog.table_name]
      env = merge(
        {
          DYNAMODB_CATALOG_TABLE    = module.catalog.table_name
          DYNAMODB_CATALOG_SK_INDEX = module.catalog.sk_index_name
          COGNITO_ISSUER_URI        = module.cognito.user_pool_issuer
        },
        var.enable_opensearch ? {
          OPENSEARCH_ENDPOINT = module.opensearch[0].endpoint
        } : {}
      )
    }

    user-service = {
      paths           = ["/me/*"]
      dynamodb_tables = [module.users.table_name]
      env = {
        DYNAMODB_USERS_TABLE = module.users.table_name
        COGNITO_ISSUER_URI   = module.cognito.user_pool_issuer
      }
    }
  }

  cloudfront_frontend_urls = compact([
    module.cloudfront_frontend.distribution_https_url,
    var.local_frontend_url
  ])

  cloudfront_frontend_origins = {
    frontend_assets    = module.s3.buckets.frontend_assets
    frontend_snapshots = module.s3.buckets.frontend_snapshots
  }

  cloudfront_cdn_origins = {
    content_public    = module.s3.buckets.content_public
    content_protected = module.s3.buckets.content_protected
    video_processed   = module.s3.buckets.video_processed
  }

  cloudfront_origins = merge(
    {
      for k, v in local.cloudfront_frontend_origins :
      k => merge(v, { cf_arn = module.cloudfront_frontend.distribution_arn })
    },
    {
      for k, v in local.cloudfront_cdn_origins :
      k => merge(v, { cf_arn = module.cloudfront_cdn.distribution_arn })
    }
  )
}
