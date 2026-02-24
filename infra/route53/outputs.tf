output "acm_validation_fqdns" {
  value = [
    for r in aws_route53_record.acm_validation :
    r.fqdn
  ]
}
