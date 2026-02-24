resource "aws_route53domains_registered_domain" "this" {
  domain_name = var.domain_name

  name_server {
    name = aws_route53_zone.this.name_servers[0]
  }

  name_server {
    name = aws_route53_zone.this.name_servers[1]
  }

  name_server {
    name = aws_route53_zone.this.name_servers[2]
  }

  name_server {
    name = aws_route53_zone.this.name_servers[3]
  }
}

resource "aws_route53_zone" "this" {
  name = var.domain_name
}

resource "aws_route53_record" "apigw" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "api.nexa"
  type    = "A"

  alias {
    name                   = var.apigw_domain_name
    zone_id                = var.apigw_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "cdn.nexa"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
