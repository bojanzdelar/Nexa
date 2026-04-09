variable "services" {
  type = map(object({
    paths           = list(string)
    dynamodb_tables = list(string)
    env             = map(string)
  }))
}
