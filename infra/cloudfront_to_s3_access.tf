data "aws_iam_policy_document" "cloudfront_read" {
  for_each = local.cloudfront_origins

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${each.value.bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [each.value.cf_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront" {
  for_each = local.cloudfront_origins

  bucket = each.value.bucket_name
  policy = data.aws_iam_policy_document.cloudfront_read[each.key].json
}



