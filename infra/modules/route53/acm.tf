resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in var.acm_domain_validation_options :
    dvo.resource_record_name => dvo...
  }

  zone_id = aws_route53_zone.this.zone_id
  name    = each.key
  type    = each.value[0].resource_record_type
  ttl     = 300
  records = [each.value[0].resource_record_value]
}
