variable "web_acl_arn" {
  type = string
}

variable "public_key_value" {
  type = string
}

variable "origins" {
  type = map(object({
    id          = string
    domain_name = string
  }))
}

variable "domain_name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}
