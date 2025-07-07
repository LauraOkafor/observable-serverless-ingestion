# 🧠 Observable Serverless Ingestion Pipeline with Terraform
Build a fully serverless, observable data ingestion pipeline using AWS + Terraform. This pipeline reads files uploaded to S3, transforms the data with Lambda, stores it in DynamoDB, queues it through SQS, and notifies via SNS all with full observability using CloudWatch and X-Ray.
__________________________________________________________________________________________________
## 🎯 What You'll Build
By the end of this tutorial, you'll have a complete serverless pipeline that:
- Automatically processes files uploaded to S3
- Transforms and stores data in DynamoDB
- Handles failures gracefully with SQS and Dead Letter Queues
- Sends notifications via SNS
- Includes comprehensive monitoring and alerting
__________________________________________________________________________________________________
## 📁 Project Structure
Here's the complete structure we'll create:

observable-serverless-ingestion/
├── cloudwatch.tf              # Logging, X-Ray, and custom metrics
├── consumer_lambda.zip        # Packaged SQS consumer Lambda
├── dynamodb.tf                # DynamoDB table definition
├── iam.tf                     # IAM roles and permissions
├── lambda/
│   ├── consumer_handler.py    # SQS consumer logic
│   └── handler.py             # S3 trigger logic
├── lambda.tf                  # Lambda function resources
├── lambda.zip                 # Packaged producer Lambda
├── main.tf                    # Terraform root module
├── outputs.tf                 # Useful Terraform outputs
├── s3.tf                      # S3 bucket configuration
├── sns.tf                     # SNS topic and subscriptions
├── sqs.tf                     # SQS and DLQ resources
├── terraform.tfvars           # Variable values
└── tvariables.tf              # Variable declarations
__________________________________________________________________________________________________

## 🚀 Step-by-Step Implementation Guide

### Step 1: Create the Project Structure
```bash
mkdir observable-serverless-ingestion
cd observable-serverless-ingestion
mkdir lambda
```
__________________________________________________________________________________________________

### Step 2: Add Terraform Configuration Files

To avoid writing any code from scratch, all Terraform configuration files are already available in the GitHub repository.

📁 Navigate to the GitHub repo:
👩‍💻 GitHub: https://github.com/LauraOkafor/observable-serverless-ingestion

📝 Then copy each of the following files directly from the project root:
- variables.tf — defines input variables like AWS region, email, and Lambda config.

- main.tf — configures provider details and local tags.

💡 These files are well-structured and ready to use. Just open them in the repo, copy their contents, and paste them into your local project.

__________________________________________________________________________________________________
### Step 3: Provision AWS Resources

Continue copying the following files from the same repository. Each one handles a specific AWS service:

- s3.tf — Sets up an S3 bucket with versioning, encryption, and S3-to-Lambda trigger.

- dynamodb.tf — Creates a DynamoDB table with point-in-time recovery.

- sqs.tf — Defines both a main SQS queue and a Dead Letter Queue (DLQ).

- sns.tf — Creates an SNS topic and subscribes an email address to it.

- iam.tf — Attaches IAM roles and permissions for Lambda to interact with other AWS services.

- lambda.tf — Configures both Lambda functions (S3 processor and SQS consumer).

- cloudwatch.tf — Adds CloudWatch log groups, metrics, and alarms for observability.

- outputs.tf — Declares output values for quick visibility into resources.

Each of these .tf files is already in the root folder of the GitHub repository.
__________________________________________________________________________________________________
### Step 4: Add Lambda Function Code

In your local lambda/ folder, create two Python files:

- handler.py — This is the S3-triggered function.

- consumer_handler.py — This is the SQS-triggered function.

👉 To get the exact code:

Open the lambda/ folder in the GitHub repo

Copy the content of each file into your corresponding local files:

- lambda/handler.py

- lambda/consumer_handler.py
__________________________________________________________________________________________________

### ✅ Deploy the Infrastructure

Run the following commands from your project root:
```bash
terraform init
terraform plan
terraform apply
```
__________________________________________________________________________________________________

## 📍 Final Checks

After uploading your test file:

1. Verify S3 Bucket
Go to: S3 Console → Your bucket
Screenshot:
--- 

2. Verify Lambda Trigger
Go to: Lambda Console → s3-triggered-transform-lambda

Click: Monitor tab → View CloudWatch logs

Look for: Recent log entries showing:

"New file uploaded: [filename] in bucket [bucket-name]"

"File content successfully read"

Screenshot:
---

3. Verify S3 Event Configuration
Go to: S3 Console → Your bucket → Properties → Event notifications

Screenshot: Lambda trigger configuration
---

4. Verify DynamoDB Table
DynamoDB Console → Tables → processed-files → Items tab
---

5. Verify SQS Message Flow
- Go to: SQS Console → file-processing-queue

- Click: Monitoring tab

- Screenshot: Message metrics showing:

- Messages Sent (spikes when file uploaded)

---
6. Check Consumer Lambda
- Go to: Lambda Console → sqs-consumer-lambda

- Click: Monitor tab → View CloudWatch logs
--- 

7. Verify DLQ (Should be Empty)
- Go to: SQS Console → file-processing-dlq

- Screenshot: 0 messages (no failures)
---

8. Verify SNS Topic
Go to: SNS Console → Topics → data-processing-topic
Click: Subscriptions tab
Check your email inbo

9. X-Ray Service Map
Go to: X-Ray Console → Service map