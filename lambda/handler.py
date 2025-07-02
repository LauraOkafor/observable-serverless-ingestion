import json
import boto3
import os

s3 = boto3.client('s3')
sqs = boto3.client('sqs')
queue_url = os.environ['SQS_URL']

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key    = record['s3']['object']['key']

        print(f"New file uploaded: {key} in bucket {bucket}")

        try:
            # Get the uploaded file
            response = s3.get_object(Bucket=bucket, Key=key)
            content = response['Body'].read().decode('utf-8')
            print("File content successfully read.")

            # Split into lines
            lines = content.strip().split('\n')

            for line in lines:
                transformed = line.upper()

                message = {
                    "file_name": key,
                    "line": line,
                    "transformed": transformed
                }

                print(f"Sending to SQS: {message}")

                sqs.send_message(
                    QueueUrl=queue_url,
                    MessageBody=json.dumps(message)
                )

        except Exception as e:
            print(f"Error processing file {key}: {e}")

    return {
        'statusCode': 200,
        'body': json.dumps('File lines sent to SQS.')
    }