variable "apigw_execution_arn" {
  type = string
}

variable "auth_layer_arn" {
  type = string
}

variable "playlist_bucket" {
  type = string
}

variable "key_endpoint" {
  type = string
}

variable "cloudfront_domain_name" {
  type = string
}

variable "public_key_id" {
  type = string
}

variable "private_key_name" {
  type = string
}

variable "playlist_signing_secret_name" {
  type = string
}

variable "segment_signing_secret_name" {
  type = string
}
