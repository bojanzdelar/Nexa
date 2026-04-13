
variable "origins" {
  type = map(object({
    id          = string
    domain_name = string
  }))
}

variable "public_key_value" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "cloudfront_frontend_urls" {
  type = list(string)
}

variable "acm_certificate_arn" {
  type = string
}

variable "web_acl_arn" {
  type = string
}
