# Root Outputs for S3 Upload API with Presigned URLs

output "api_endpoint" {
  description = "URL of the API Gateway endpoint for file uploads"
  value       = module.api_gateway.api_endpoint
}

output "api_endpoint_get_presigned_url" {
  description = "GET endpoint to generate presigned URL (for large files)"
  value       = "${module.api_gateway.api_endpoint}?filename=example.pdf&contentType=application/pdf&maxSize=104857600"
}

output "api_endpoint_post_direct_upload" {
  description = "POST endpoint for direct upload (for small files < 6MB)"
  value       = module.api_gateway.api_endpoint
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket storing uploaded files"
  value       = module.s3_bucket.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3_bucket.bucket_arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function handling uploads"
  value       = module.lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.function_arn
}

output "aws_region" {
  description = "AWS region where resources are deployed"
  value       = var.aws_region
}

output "usage_instructions" {
  description = "Instructions for using the API"
  value = <<-EOT
    
    === S3 Upload API Usage ===
    
    1. For LARGE files (> 6MB, up to 5GB):
       GET ${module.api_gateway.api_endpoint}?filename=large.pdf&contentType=application/pdf&maxSize=104857600
       Then upload directly to S3 using the returned presigned URL
    
    2. For SMALL files (< 6MB):
       POST ${module.api_gateway.api_endpoint}
       With base64-encoded file in request body
    
    3. Browser upload:
       Open browser-upload-example.html and update API_ENDPOINT
    
    Region: ${var.aws_region}
    Bucket: ${module.s3_bucket.bucket_name}
    
  EOT
}
