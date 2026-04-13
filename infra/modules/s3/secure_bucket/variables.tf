variable "bucket_name" {
  type = string
}

variable "bucket_suffix" {
  type = string
}

variable "enable_versioning" {
  type    = bool
  default = false
}

variable "enable_cors" {
  type    = bool
  default = false
}

variable "cloudfront_frontend_urls" {
  type    = list(string)
  default = []
}
