data "aws_iam_policy_document" "opensearch_access" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.allowed_role_arns
    }

    actions   = ["es:*"]
    resources = ["${aws_opensearch_domain.search.arn}/*"]
  }
}

resource "aws_opensearch_domain_policy" "this" {
  domain_name     = aws_opensearch_domain.search.domain_name
  access_policies = data.aws_iam_policy_document.opensearch_access.json
}
