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

resource "aws_route53_record" "api" {
  count = var.enable_alb ? 1 : 0

  zone_id = aws_route53_zone.this.zone_id
  name    = "api.nexa"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cf_edge" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "nexa"
  type    = "A"

  alias {
    name                   = var.cf_edge_domain_name
    zone_id                = var.cf_edge_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cf_cdn" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "cdn.nexa"
  type    = "A"

  alias {
    name                   = var.cf_cdn_domain_name
    zone_id                = var.cf_cdn_hosted_zone_id
    evaluate_target_health = false
  }
}
