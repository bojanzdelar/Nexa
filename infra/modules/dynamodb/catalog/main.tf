resource "aws_dynamodb_table" "nexa_catalog" {
  name                        = "NexaCatalog"
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

  global_secondary_index {
    name            = local.sk_index_name
    projection_type = "ALL"

    hash_key  = "SK"
    range_key = "PK"

    on_demand_throughput {
      max_read_request_units  = 1000
      max_write_request_units = 1000
    }
  }
}
