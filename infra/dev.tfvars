enable_alb         = false
ecs_desired_count  = 0
enable_opensearch  = false
enable_cf_waf      = false
enable_snapshots   = false
local_frontend_url = "http://localhost:3000"
environment        = "dev"

app_domain_name    = "nexa.zdelar.com"
root_domain_name   = "zdelar.com"
notification_email = "nexa@zdelar.com"
email_domain_name  = "zdelar.com"
aws_region         = "eu-central-1"
s3_bucket_suffix   = "" # helps avoid global S3 bucket name collisions (e.g. use account ID)
