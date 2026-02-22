variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "hls_signing_secret" {
  type      = string
  sensitive = true
}

variable "enable_opensearch" {
  type    = bool
  default = false
}
