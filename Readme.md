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
## Architecture Overview
![diagram-export-05-07-2025-00_43_00](https://github.com/user-attachments/assets/c9d942c9-0265-445a-b23b-84c506d69c3f)

___________________________________________________________________________________________________________________________________
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
<img width="1431" alt="Screenshot 2025-07-07 at 20 58 48" src="https://github.com/user-attachments/assets/be0b0d1f-f1ee-4218-8648-c645dbacecb7" />

--- 

2. Verify Lambda Trigger
Go to: Lambda Console → s3-triggered-transform-lambda

Click: Monitor tab → View CloudWatch logs

Look for: Recent log entries showing:

"New file uploaded: [filename] in bucket [bucket-name]"

"File content successfully read"

Screenshot:
<img width="1393" alt="Screenshot 2025-07-07 at 21 39 19" src="https://github.com/user-attachments/assets/ac1330cb-5e38-4070-8dfa-7ee8dd76e355" />
<img width="1393" alt="Screenshot 2025-07-07 at 21 13 57" src="https://github.com/user-attachments/assets/c36ad4ed-0325-4ddc-870c-f03ca67ea339" />

---

3. Verify S3 Event Configuration
Go to: S3 Console → Your bucket → Properties → Event notifications

Screenshot: Lambda trigger configuration
<img width="1424" alt="Screenshot 2025-07-07 at 21 43 17" src="https://github.com/user-attachments/assets/bd4b95a2-1121-45b6-84d1-73f24baf9ba6" />

---

4. Verify DynamoDB Table
DynamoDB Console → Tables → processed-files → Items tab

Screenshot:
<img width="1552" alt="Screenshot 2025-07-07 at 21 46 00" src="https://github.com/user-attachments/assets/f8a51941-00fd-4746-a9e7-ce43960700cd" />


---

5. Verify SQS Message Flow
- Go to: SQS Console → file-processing-queue

- Click: Monitoring tab

- Screenshot: Message metrics showing:

- Messages Sent (spikes when file uploaded)
<img width="1552" alt="Screenshot 2025-07-07 at 21 51 18" src="https://github.com/user-attachments/assets/d9aa8ccb-c0fb-4e5b-8362-825fb5fed01c" />
<img width="1552" alt="Screenshot 2025-07-07 at 21 48 54" src="https://github.com/user-attachments/assets/22da63fa-7a97-4f32-92d1-f2982f9204b2" />

---
6. Check Consumer Lambda
- Go to: Lambda Console → sqs-consumer-lambda

- Click: Monitor tab → View CloudWatch logs
  
Screenshot:
<img width="1552" alt="Screenshot 2025-07-07 at 21 53 34" src="https://github.com/user-attachments/assets/2fe22cfe-6ca6-4943-8265-93de391bfac3" />


--- 

7. Verify DLQ (Should be Empty)
- Go to: SQS Console → file-processing-dlq

- Screenshot: 0 messages (no failures)
<img width="1424" alt="Screenshot 2025-07-07 at 21 56 05" src="https://github.com/user-attachments/assets/68039749-db2d-43c4-ae76-7a6d2a642836" />

---

8. Verify SNS Topic
Go to: SNS Console → Topics → data-processing-topic
Check your email inbox
screenshot:
<img width="1198" alt="Screenshot 2025-07-07 at 22 07 00" src="https://github.com/user-attachments/assets/f891dd2b-6f1d-4449-aa06-69d38bf746d7" />
<img width="1198" alt="Screenshot 2025-07-07 at 22 06 51" src="https://github.com/user-attachments/assets/34f64803-fa7a-4e61-9f78-4db22a0dbcb9" />


10. X-Ray Service Map
Go to: X-Ray Console → Service map
