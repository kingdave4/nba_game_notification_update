# This file contains the main Terraform configuration for the NBA Game Updates project.

# Creates an IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "nba_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach the AWS managed policy for Lambda execution
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "nba_lambda_policy"
  role   = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect   = "Allow",
        Action   = ["sns:Publish"],
        Resource = aws_sns_topic.nba_topic.arn
      }
    ]
  })
}


# Create SNS Topic for NBA Game Updates
resource "aws_sns_topic" "nba_topic" {
  name = "nba_game_updates"
}

# create Lambda function
resource "aws_lambda_function" "nba_lambda" {
  function_name = "nba_game_data_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"

  # Path to your Lambda deployment package (ZIP file with the Python code)
  filename = "../lambda/nba_game_lambda.zip"

  # set the environment variables
  environment {
    variables = {
      NBA_API_KEY    = var.nba_api_key
      SNS_TOPIC_ARN  = aws_sns_topic.nba_topic.arn
    }
  }
}

# Lambda Permission for SNS
resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.nba_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.nba_topic.arn
}


# The ARN of the SNS topic to which game updates are published. Used in the Lambda function to send updates.
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.nba_topic.arn
  protocol  = "email"
  endpoint  = "kingofcloud13@gmail.com" # Replace with the desired email address
}


# Lambda Permission for EventBridge
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.nba_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_rule.arn
}

# EventBridge Rule to trigger Lambda every 2 hours
resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name        = "nba_game_update_schedule"
  description = "Schedule to trigger Lambda every 2 hours"
  # This cron expression triggers the Lambda function every 2 hours. Format: (minute, hour, day, month, weekday).
  schedule_expression = "cron(0 */2 * * ? *)"
}

# EventBridge Target to trigger Lambda
resource "aws_cloudwatch_event_target" "schedule_target" {
  rule      = aws_cloudwatch_event_rule.schedule_rule.name
  target_id = "nba_lambda"
  arn       = aws_lambda_function.nba_lambda.arn
}
