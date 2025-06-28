import json
import boto3
import os

# Initialize DynamoDB
dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('DYNAMO_TABLE')
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    s3 = boto3.client('s3')

    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key    = record['s3']['object']['key']  # This is the file name

        print(f"New file uploaded: {key} in bucket {bucket}")

        try:
            response = s3.get_object(Bucket=bucket, Key=key)
            content = response['Body'].read()

            try:
                text = content.decode('utf-8')
                print("File content successfully read.")

                # Save entire file content into DynamoDB under file_name key
                item = {
                    'file_name': key,  # Must match your table's hash key
                    'content': text    # Store entire content in one item
                }

                table.put_item(Item=item)
                print(f"Saved to DynamoDB: {item}")

            except Exception as decode_error:
                print(f"Could not decode file as text: {decode_error}")
                print(f"Binary file detected. Size: {len(content)} bytes")

        except Exception as read_error:
            print(f"Error reading file from S3: {read_error}")

    return {
        'statusCode': 200,
        'body': json.dumps('File content saved to DynamoDB.')
    }