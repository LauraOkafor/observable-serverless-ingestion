import json
import boto3
import os
from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.core import patch_all

# Patch all AWS SDK calls for X-Ray tracing
patch_all()

# Initialize AWS clients
s3 = boto3.client('s3')
sqs = boto3.client('sqs')
cloudwatch = boto3.client('cloudwatch')

# Read the SQS queue URL from environment variable
queue_url = os.environ['SQS_URL']

#CloudWatch Custom Metrics Setup
def publish_line_count(count, context):
    cloudwatch.put_metric_data(
        Namespace='ObservableIngestionApp',
        MetricData=[
            {
                'MetricName': 'LinesProcessed',
                'Dimensions': [
                    {
                        'Name': 'FunctionName',
                        'Value': context.function_name
                    },
                ],
                'Unit': 'Count',
                'Value': count
            },
        ]
    )
    
# Main Lambda handler 
@xray_recorder.capture('lambda_handler')
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
                
                # Send to SQS queue
                sqs.send_message(
                    QueueUrl=queue_url,
                    MessageBody=json.dumps(message)
                )
                
            # Publish count of processed lines to CloudWatch
            publish_line_count(len(lines), context)
            
        except Exception as e:
            print(f"Error processing file {key}: {e}")

    return {
        'statusCode': 200,
        'body': json.dumps('File lines sent to SQS.')
    }