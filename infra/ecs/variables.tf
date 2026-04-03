variable "services" {
  type = map(object({
    env = map(string)
  }))
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "enable_opensearch" {
  type = bool
}
