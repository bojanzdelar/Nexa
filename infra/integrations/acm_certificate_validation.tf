resource "aws_acm_certificate_validation" "global" {
  provider                = aws.us_east_1
  certificate_arn         = var.certificates.global_arn
  validation_record_fqdns = var.certificates.fqdns
}

resource "aws_acm_certificate_validation" "regional" {
  provider                = aws
  certificate_arn         = var.certificates.regional_arn
  validation_record_fqdns = var.certificates.fqdns
}
