resource "aws_dynamodb_table" "nexa_users" {
  name                        = "NexaUsers"
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = true

  hash_key  = "PK"
  range_key = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  on_demand_throughput {
    max_read_request_units  = 1000
    max_write_request_units = 1000
  }

  ttl {
    attribute_name = "expiresAt"
    enabled        = true
  }
}
