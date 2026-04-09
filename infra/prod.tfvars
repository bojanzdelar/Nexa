ssr_provisioned_concurrency = 1
enable_alb                  = true
ecs_desired_count           = 1
enable_opensearch           = true
enable_cf_cdn_waf           = true
enable_cf_frontend_waf      = false # TODO: change to true
environment                 = "prod"

app_domain_name    = "nexa.zdelar.com"
root_domain_name   = "zdelar.com"
notification_email = "nexa@zdelar.com"
email_domain_name  = "zdelar.com"
aws_region         = "eu-central-1"
s3_bucket_prefix   = ""
