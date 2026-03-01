resource "aws_cloudfront_public_key" "media" {
  name        = "media-public-key"
  encoded_key = var.public_key_value

  lifecycle {
    ignore_changes = [encoded_key]
  }
}

resource "aws_cloudfront_key_group" "media" {
  name  = "media-key-group"
  items = [aws_cloudfront_public_key.media.id]
}
