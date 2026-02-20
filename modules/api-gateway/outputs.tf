# Outputs for API Gateway Module

output "api_id" {
  description = "ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.upload_api.id
}

output "api_endpoint" {
  description = "Full URL of the API endpoint for file uploads"
  value       = "${aws_api_gateway_deployment.upload_api.invoke_url}${aws_api_gateway_stage.upload_api.stage_name}/upload"
}

output "api_arn" {
  description = "ARN of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.upload_api.arn
}

output "api_execution_arn" {
  description = "Execution ARN of the API Gateway (for Lambda permissions)"
  value       = aws_api_gateway_rest_api.upload_api.execution_arn
}

output "stage_name" {
  description = "Name of the deployed API Gateway stage"
  value       = aws_api_gateway_stage.upload_api.stage_name
}

output "stage_invoke_url" {
  description = "Base invoke URL for the API Gateway stage"
  value       = aws_api_gateway_deployment.upload_api.invoke_url
}
