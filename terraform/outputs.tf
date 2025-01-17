output "sns_topic_arn" {
  value = aws_sns_topic.nba_topic.arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.nba_lambda.arn
}
