variable "domain_name" {
  type = string
}

variable "cf_edge_domain_name" {
  type = string
}

variable "cf_edge_hosted_zone_id" {
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
