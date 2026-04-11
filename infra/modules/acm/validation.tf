resource "aws_route53_record" "this" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.domain_name => dvo
  }

  zone_id = var.route53_zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 300
  records = [each.value.resource_record_value]

  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  provider        = aws
  certificate_arn = aws_acm_certificate.this.arn
  validation_record_fqdns = [
    for r in aws_route53_record.this :
    r.fqdn
  ]
}
