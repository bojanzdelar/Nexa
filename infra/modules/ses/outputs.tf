output "domain_identity_arn" {
  value = aws_ses_domain_identity.this.arn
}

output "domain_dkim" {
  value = aws_ses_domain_dkim.this.dkim_tokens
}
