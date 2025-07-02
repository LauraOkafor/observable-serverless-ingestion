# Package the Python script into a ZIP file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/handler.py"
  output_path = "${path.module}/lambda.zip"
}

# Package the SQS consumer Lambda into a ZIP file
data "archive_file" "lambda_consumer_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/consumer_handler.py"
  output_path = "${path.module}/consumer_lambda.zip"
}


# Create the Lambda function that reads S3 files and inserts into DynamoDB
resource "aws_lambda_function" "transform_lambda" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "handler.lambda_handler" # points to handler.py and lambda_handler function
  runtime          = "python3.9"
  timeout          = 10
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.data_table.name
      SQS_URL      = aws_sqs_queue.main_queue.url
    }
  }
}

# Allow S3 bucket to invoke the Lambda
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transform_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.my_bucket.arn
}

# Create the Lambda function that is triggered by SQS,
# reads transformed data, writes to DynamoDB, and publishes to SNS
resource "aws_lambda_function" "consumer_lambda" {
  function_name    = "sqs-consumer-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "consumer_handler.lambda_handler"
  runtime          = "python3.9"
  timeout          = 10
  filename         = data.archive_file.lambda_consumer_zip.output_path
  source_code_hash = data.archive_file.lambda_consumer_zip.output_base64sha256

  environment {
    variables = {
      DYNAMO_TABLE  = aws_dynamodb_table.data_table.name
      SNS_TOPIC_ARN = aws_sns_topic.notify_topic.arn
    }
  }
}

