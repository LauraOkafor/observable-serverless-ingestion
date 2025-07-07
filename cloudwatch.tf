# CloudWatch Alarms for Day 6

# Alarm for Lambda errors (>10 errors/hour)
resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "lambda-high-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "3600"  # 1 hour
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors lambda error rate"
  alarm_actions       = [aws_sns_topic.notify_topic.arn]

  dimensions = {
    FunctionName = aws_lambda_function.transform_lambda.function_name
  }
}

# Alarm for Lambda duration (high performance)
resource "aws_cloudwatch_metric_alarm" "lambda_duration_alarm" {
  alarm_name          = "lambda-high-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "300"  # 5 minutes
  statistic           = "Average"
  threshold           = "5000"  # 5 seconds
  alarm_description   = "This metric monitors lambda duration"
  alarm_actions       = [aws_sns_topic.notify_topic.arn]

  dimensions = {
    FunctionName = aws_lambda_function.transform_lambda.function_name
  }
}

# Alarm for SQS queue depth
resource "aws_cloudwatch_metric_alarm" "sqs_queue_depth_alarm" {
  alarm_name          = "sqs-queue-depth-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ApproximateNumberOfVisibleMessages"
  namespace           = "AWS/SQS"
  period              = "300"
  statistic           = "Average"
  threshold           = "100"
  alarm_description   = "This metric monitors SQS queue depth"
  alarm_actions       = [aws_sns_topic.notify_topic.arn]

  dimensions = {
    QueueName = aws_sqs_queue.main_queue.name
  }
}

# Custom business metric alarm
resource "aws_cloudwatch_metric_alarm" "custom_lines_processed_alarm" {
  alarm_name          = "low-lines-processed"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "LinesProcessed"
  namespace           = "ObservableIngestionApp"
  period              = "3600"  # 1 hour
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This metric monitors business processing volume"
  alarm_actions       = [aws_sns_topic.notify_topic.arn]
  treat_missing_data  = "breaching"

  dimensions = {
    FunctionName = aws_lambda_function.transform_lambda.function_name
  }
}