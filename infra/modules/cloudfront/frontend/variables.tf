variable "s3_assets_origin_domain_name" {
  type = string
}

variable "lambda_origin_domain" {
  type = string
}

variable "s3_snapshots_origin_domain_name" {
  type = string
}

variable "failover_rewrite_lambda_arn" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "web_acl_arn" {
  type = string
}
