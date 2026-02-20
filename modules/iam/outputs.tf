# Outputs for IAM Module

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_execution.arn
}

output "lambda_role_name" {
  description = "Name of the Lambda execution role"
  value       = aws_iam_role.lambda_execution.name
}

output "lambda_role_id" {
  description = "ID of the Lambda execution role"
  value       = aws_iam_role.lambda_execution.id
}
