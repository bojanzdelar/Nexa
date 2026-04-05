variable "services" {
  type = map(object({
    paths           = list(string)
    dynamodb_tables = list(string)
    env             = map(string)
  }))
}

variable "container_port" {
  type = number
}

variable "acm_certificate_arn" {
  type = string
}
