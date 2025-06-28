output "bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}

output "lambda_name" {
  value = aws_lambda_function.transform_lambda.function_name
}