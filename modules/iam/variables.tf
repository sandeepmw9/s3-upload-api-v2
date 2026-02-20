# Variables for IAM Module

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]{1,64}$", var.lambda_function_name))
    error_message = "Lambda function name must be 1-64 characters, alphanumeric, hyphens, and underscores only."
  }
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket for Lambda permissions"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3:::[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.s3_bucket_arn))
    error_message = "Must be a valid S3 bucket ARN (arn:aws:s3:::bucket-name)."
  }
}

variable "tags" {
  description = "Tags to apply to IAM resources"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[\\w\\s+=.:\\/@-]{1,128}$", k))])
    error_message = "Tag keys must be 1-128 characters and contain only letters, numbers, spaces, and +=.:/@- characters."
  }
}
