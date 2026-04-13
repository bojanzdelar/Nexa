variable "hls_key_lambda_invoke_arn" {
  type = string
}

variable "hls_playlist_token_lambda_invoke_arn" {
  type = string
}

variable "hls_playlist_lambda_invoke_arn" {
  type = string
}

variable "subtitles_manifest_lambda_invoke_arn" {
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
