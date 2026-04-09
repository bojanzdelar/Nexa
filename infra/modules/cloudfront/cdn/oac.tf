resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "nexa-cdn-s3-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
