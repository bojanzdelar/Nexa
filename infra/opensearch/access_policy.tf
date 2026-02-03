data "aws_iam_policy_document" "opensearch_access" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"] # TODO: aws_iam_role.opensearch_app_role.arn
    }

    actions   = ["es:*"]
    resources = ["${aws_opensearch_domain.search.arn}/*"]
  }
}

resource "aws_opensearch_domain_policy" "this" {
  domain_name     = aws_opensearch_domain.search.domain_name
  access_policies = data.aws_iam_policy_document.opensearch_access.json
}
