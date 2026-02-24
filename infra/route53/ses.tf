resource "aws_route53_record" "ses_mx" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "nexa"
  type    = "MX"
  ttl     = 300

  records = [
    "10 feedback-smtp.${var.ses_region}.amazonses.com."
  ]
}

resource "aws_route53_record" "ses_spf" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "nexa"
  type    = "TXT"
  ttl     = 300

  records = [
    "v=spf1 include:amazonses.com ~all"
  ]
}

resource "aws_route53_record" "ses_dmarc" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "_dmarc"
  type    = "TXT"
  ttl     = 300

  records = [
    "v=DMARC1; p=none;"
  ]
}

locals {
  ses_dkim_map = {
    dkim1 = var.ses_domain_dkim[0]
    dkim2 = var.ses_domain_dkim[1]
    dkim3 = var.ses_domain_dkim[2]
  }
}

resource "aws_route53_record" "ses_dkim" {
  for_each = local.ses_dkim_map

  zone_id = aws_route53_zone.this.zone_id
  name    = "${each.value}._domainkey"
  type    = "CNAME"
  ttl     = 300
  records = ["${each.value}.dkim.amazonses.com"]
}
