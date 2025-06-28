resource "aws_sns_topic" "notify_topic" {
  name = "data-processing-topic"
}

resource "aws_sns_topic_subscription" "email_subscriber" {
  topic_arn = aws_sns_topic.notify_topic.arn
  protocol  = "email"
  endpoint  = "lauraamanda56@gmail.com" # ← Replace this with your email
}