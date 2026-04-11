resource "aws_ssm_parameter" "hls_playlist_signing_secret" {
  name  = "/nexa/internal/hls/playlist/signing_secret"
  type  = "SecureString"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "hls_segment_signing_secret" {
  name  = "/nexa/internal/hls/segment/signing_secret"
  type  = "SecureString"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "cloudfront_private_key" {
  name  = "/nexa/internal/cloudfront/media_private_key"
  type  = "SecureString"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "cloudfront_public_key" {
  name  = "/nexa/internal/cloudfront/media_public_key"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}
