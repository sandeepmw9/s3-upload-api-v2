# Outputs for S3 Bucket Module

output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.pdf_storage.id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.pdf_storage.arn
}

output "bucket_region" {
  description = "Region where the bucket is created"
  value       = aws_s3_bucket.pdf_storage.region
}

output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.pdf_storage.bucket_domain_name
}
