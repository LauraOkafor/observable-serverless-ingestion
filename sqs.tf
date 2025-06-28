resource "aws_sqs_queue" "main_queue" {
  name = "file-processing-queue"
}

resource "aws_sqs_queue" "dlq" {
  name = "file-processing-dlq"
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.main_queue.arn
  function_name    = aws_lambda_function.consumer_lambda.arn
  batch_size       = 10
  enabled          = true
}