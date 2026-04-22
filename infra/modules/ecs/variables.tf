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

variable "enable_alb" {
  type = bool
}

variable "target_group_arns" {
  type = map(string)
}

variable "desired_count" {
  type = number
}

variable "enable_opensearch" {
  type = bool
}

variable "opensearch_domain_arn" {
  type = string
}

variable "origin_secret" {
  type = string
}
