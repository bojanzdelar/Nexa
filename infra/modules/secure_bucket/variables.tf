variable "bucket_name" {
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

variable "allow_cloudfront_access" {
  type    = bool
  default = false
}

variable "cloudfront_distribution_arn" {
  type    = string
  default = null
}
