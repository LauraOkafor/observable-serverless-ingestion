resource "aws_dynamodb_table" "data_table" {
  name         = "processed-files"
  billing_mode = "PAY_PER_REQUEST" # No need to manage read/write capacity
  hash_key     = "file_name"       # Primary key

  attribute {
    name = "file_name"
    type = "S"
  }
}