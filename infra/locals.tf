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
}
