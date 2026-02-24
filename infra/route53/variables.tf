variable "domain_name" {
  type = string
}

variable "apigw_domain_name" {
  type = string
}

variable "apigw_hosted_zone_id" {
  type = string
}

variable "cloudfront_domain_name" {
  type = string
}

variable "cloudfront_hosted_zone_id" {
  type = string
}

variable "ses_region" {
  type = string
}

variable "ses_domain_dkim" {
  type = list(string)
}

variable "acm_domain_validation_options" {
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}
