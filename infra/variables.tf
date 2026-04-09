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

variable "s3_bucket_prefix" {
  type = string
}

variable "enable_alb" {
  type = bool
}

variable "ecs_desired_count" {
  type = number
}

variable "enable_opensearch" {
  type = bool
}

variable "enable_cf_cdn_waf" {
  type = bool
}

variable "enable_cf_frontend_waf" {
  type = bool
}

variable "container_port" {
  type    = number
  default = 8080
}
