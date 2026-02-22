variable "apigw_execution_arn" {
  type = string
}

variable "signing_secret" {
  type      = string
  sensitive = true
}
