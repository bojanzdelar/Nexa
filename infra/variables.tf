variable "app_domain_name" {
  type = string
}

variable "root_domain_name" {
  type = string
}

variable "notification_email" {
  type = string
}

variable "email_domain_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "enable_opensearch" {
  type    = bool
  default = false
}
