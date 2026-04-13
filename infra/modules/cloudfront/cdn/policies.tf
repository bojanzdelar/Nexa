resource "aws_cloudfront_response_headers_policy" "cors_with_credentials" {
  name = "nexa-cors-with-credentials"

  cors_config {
    access_control_allow_credentials = true

    access_control_allow_headers {
      items = ["Origin", "Content-Type", "Accept", "Authorization"]
    }

    access_control_allow_methods {
      items = ["GET", "HEAD", "OPTIONS"]
    }

    access_control_allow_origins {
      items = var.cloudfront_frontend_urls
    }

    origin_override = true
  }
}
