# Welcome to my 2nd Project of the 30 Days Devops Challenge!. 

I am excited to continue this journey of learning cloud technologies and tackling all the hands-on projects.
I decided to add my own challenge into the project by deploying it with Terraform to add automation to the entire process.
I first did the project through AWS console but then i decided to make it a little bit more challenging more efficient.


## NBA Game Updates Project

This project is designed to fetch NBA game updates and deliver them to subscribers via email using AWS services. It leverages AWS Lambda, SNS (Simple Notification Service), and EventBridge for automation and notifications. Terraform is used to define and deploy the infrastructure as code.


## **Features**
- Fetches real-time NBA game data using an external API.
- Publishes formatted game updates to an AWS SNS topic.
- Sends game updates to email subscribers.
- Automates periodic execution using AWS EventBridge.

---

## **Architecture Overview**
1. **Lambda Function**:
   - Fetches NBA game data from an external API.
   - Formats the data based on game status (e.g., Scheduled, InProgress, Final).
   - Publishes the updates to an SNS topic.

2. **SNS Topic**:
   - Acts as a message broker, forwarding updates to subscribers (email in this case).

3. **EventBridge**:
   - Triggers the Lambda function every 2 hours to ensure timely updates.

4. **IAM Roles and Policies**:
   - Securely grant the Lambda function the necessary permissions to publish to SNS and log data to CloudWatch.

---

## **Pre-Requisites**
- An AWS account.
- Terraform installed on your local machine.
- An API key for the external NBA game data API (e.g., SportsData.io).

---

## **Setup Instructions**

### **1. Clone the Repository**
```bash
git clone https://github.com/kingdave4/nba_game_notification_schedule.git
cd nba-game-updates
```

### **2. Configure Environment Variables**
Ensure the following variables are set in Terraform:
- `NBA_API_KEY`: Your API key for the NBA data provider.
- `SNS_TOPIC_ARN`: The ARN of the SNS topic for notifications.

### **3. Update Email Subscription**
In the `aws_sns_topic_subscription` resource, replace the `endpoint` with your desired email address:
```hcl
endpoint = "your-email@example.com"
```

### **4. Deploy the Infrastructure**
Run the following Terraform commands to deploy the resources:
```bash
terraform init
terraform plan
terraform apply
```

### **5. Confirm Email Subscription**
Check your email inbox and confirm the subscription to the SNS topic.

---

## **How It Works**
1. The **EventBridge rule** triggers the Lambda function every 2 hours.
2. The **Lambda function**:
   - Fetches game data for the current day from the NBA API.
   - Formats the data and publishes it to the **SNS topic**.
3. The **SNS topic** sends the updates to all subscribed email addresses.

---

## **Key Files**
- **lambda/nba_game_lambda.zip**: Contains the Python code for the Lambda function.
- **main.tf**: Terraform configuration file for defining AWS resources.
- **variables.tf**: Terraform variables file.
- **outputs.tf**: Outputs information such as the SNS topic ARN.

---

## **Technologies Used**
- **AWS Services**:
  - Lambda
  - SNS
  - EventBridge
  - IAM (for permissions)
- **Terraform**: Infrastructure as Code (IaC) tool.
- **Python**: For the Lambda function code.

---

## **Future Enhancements**
- Add support for SMS notifications.
- Implement filters to customize updates for specific teams.
- Include error handling for API failures and retries.
- Integrate with a front-end dashboard to display game updates in real time.

---

## **Troubleshooting**
1. **No Emails Received**:
   - Ensure you confirmed the SNS subscription via the email link.
   - Verify the email address in the `aws_sns_topic_subscription` resource.

2. **Errors in Lambda Execution**:
   - Check the CloudWatch logs for the Lambda function.
   - Verify that the `NBA_API_KEY` is correctly set and valid.

3. **Terraform Errors**:
   - Ensure your AWS credentials are configured correctly.
   - Run `terraform validate` to check for syntax issues.


## NBA Game Updates received from SNS

![image](https://github.com/user-attachments/assets/eadb9504-f300-45c9-9f0d-81363d826ceb)


