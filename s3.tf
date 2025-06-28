resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

# When someone uploads a file, tell Lambda about it
resource "aws_s3_bucket_notification" "file_upload" {
  bucket = aws_s3_bucket.my_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.transform_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}