resource "aws_cloudfront_origin_request_policy" "all_viewer" {
  name = "nexa-frontend-all-viewer"

  cookies_config {
    cookie_behavior = "all"
  }

  headers_config {
    header_behavior = "allViewer"
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}
