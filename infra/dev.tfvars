ssr_provisioned_concurrency = 0
enable_alb                  = false
ecs_desired_count           = 0
enable_opensearch           = false
enable_cf_cdn_waf           = true # change your CF plan to free or disable WAF to avoid costs
enable_cf_frontend_waf      = false
environment                 = "dev"

app_domain_name    = "nexa.zdelar.com"
root_domain_name   = "zdelar.com"
notification_email = "nexa@zdelar.com"
email_domain_name  = "zdelar.com"
aws_region         = "eu-central-1"
s3_bucket_suffix   = "" # helps avoid global S3 bucket name collisions (e.g. use account ID)
