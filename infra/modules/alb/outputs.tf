output "dns_name" {
  value = aws_lb.this.dns_name
}

output "zone_id" {
  value = aws_lb.this.zone_id
}

output "target_group_arns" {
  value = {
    for k, tg in aws_lb_target_group.services :
    k => tg.arn
  }
}
