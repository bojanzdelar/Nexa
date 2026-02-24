resource "aws_acm_certificate_validation" "global" {
  provider                = aws.us_east_1
  certificate_arn         = module.acm_global.certificate_arn
  validation_record_fqdns = module.route53.acm_validation_fqdns
}

resource "aws_acm_certificate_validation" "regional" {
  provider                = aws
  certificate_arn         = module.acm_regional.certificate_arn
  validation_record_fqdns = module.route53.acm_validation_fqdns
}
