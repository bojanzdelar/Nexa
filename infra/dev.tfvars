enable_alb             = false
ecs_desired_count      = 0
enable_opensearch      = false
enable_cf_cdn_waf      = true # change your cf plan to free or disable to avoid costs
enable_cf_frontend_waf = false
environment            = "dev"

app_domain_name    = "nexa.zdelar.com"
root_domain_name   = "zdelar.com"
notification_email = "nexa@zdelar.com"
email_domain_name  = "zdelar.com"
aws_region         = "eu-central-1"
s3_bucket_prefix   = ""
