resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = var.transcode_lambda.name
  principal     = "s3.amazonaws.com"
  source_arn    = var.video_ingest.bucket_arn
}

resource "aws_s3_bucket_notification" "video_upload_trigger" {
  bucket = var.video_ingest.bucket_name

  lambda_function {
    lambda_function_arn = var.transcode_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".mp4"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
