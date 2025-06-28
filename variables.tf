variable "bucket_name" {
  description = "Your S3 bucket name (must be unique)"
  type        = string
}

variable "aws_region" {
  description = "AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  default = "s3-triggered-transform-lambda"
}