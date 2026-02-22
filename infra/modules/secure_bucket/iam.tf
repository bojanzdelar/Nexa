data "aws_iam_policy_document" "cloudfront_read" {
  count = var.allow_cloudfront_access ? 1 : 0

  statement {
    sid     = "AllowCloudFrontOACRead"
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront" {
  count  = var.allow_cloudfront_access ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.cloudfront_read[0].json
}

