variable "cloudfront_origins" {
  type = map(object({
    bucket_name   = string
    bucket_arn    = string
    bucket_domain = string
    cf_arn        = string
  }))
}

variable "video_ingest" {
  type = object({
    bucket_name = string
    bucket_arn  = string
  })
}

variable "transcode_lambda" {
  type = object({
    name = string
    arn  = string
  })
}
