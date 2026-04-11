output "hls_playlist_signing_secret_name" {
  value = aws_ssm_parameter.hls_playlist_signing_secret.name
}

output "hls_segment_signing_secret_name" {
  value = aws_ssm_parameter.hls_segment_signing_secret.name
}

output "cloudfront_private_key_name" {
  value = aws_ssm_parameter.cloudfront_private_key.name
}

output "cloudfront_public_key_value" {
  value = aws_ssm_parameter.cloudfront_public_key.value
}
