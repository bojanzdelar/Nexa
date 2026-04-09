output "table_name" {
  value = aws_dynamodb_table.nexa_catalog.name
}

output "sk_index_name" {
  value = local.sk_index_name
}
