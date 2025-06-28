import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

table = dynamodb.Table(os.environ['DYNAMO_TABLE'])
sns_topic_arn = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    for record in event['Records']:
        message = json.loads(record['body'])

        # Write to DynamoDB
        table.put_item(Item={
            'file_name': message['file_name'],
            'original': message['line'],
            'transformed': message['transformed']
        })

        # Send SNS notification
        sns.publish(
            TopicArn=sns_topic_arn,
            Subject='✅ File Line Processed',
            Message=f"Processed line from {message['file_name']}: {message['line']} → {message['transformed']}"
        )

    return {
        'statusCode': 200,
        'body': json.dumps('Processed message(s) from SQS.')
    }