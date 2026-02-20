# Outputs for Lambda Module

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.upload_handler.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.upload_handler.function_name
}

output "function_invoke_arn" {
  description = "Invoke ARN of the Lambda function for API Gateway integration"
  value       = aws_lambda_function.upload_handler.invoke_arn
}

output "function_version" {
  description = "Latest published version of the Lambda function"
  value       = aws_lambda_function.upload_handler.version
}

output "function_qualified_arn" {
  description = "Qualified ARN of the Lambda function"
  value       = aws_lambda_function.upload_handler.qualified_arn
}
