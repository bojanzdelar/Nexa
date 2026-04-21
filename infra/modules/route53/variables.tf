variable "domain_name" {
  type = string
}

variable "enable_alb" {
  type = bool
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "cf_frontend_domain_name" {
  type = string
}

variable "cf_frontend_hosted_zone_id" {
  type = string
}

variable "cf_cdn_domain_name" {
  type = string
}

variable "cf_cdn_hosted_zone_id" {
  type = string
}

variable "ses_region" {
  type = string
}

variable "ses_domain_dkim" {
  type = list(string)
}
