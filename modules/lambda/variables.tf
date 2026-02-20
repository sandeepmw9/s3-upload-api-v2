# Variables for Lambda Module

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]{1,64}$", var.function_name))
    error_message = "Function name must be 1-64 characters, alphanumeric, hyphens, and underscores only."
  }
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to upload files to"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.s3_bucket_name))
    error_message = "Bucket name must be 3-63 characters, lowercase letters, numbers, and hyphens only."
  }
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda execution"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/", var.lambda_role_arn))
    error_message = "Must be a valid IAM role ARN."
  }
}

variable "runtime" {
  description = "Lambda runtime version"
  type        = string
  default     = "python3.11"

  validation {
    condition     = contains(["python3.9", "python3.10", "python3.11", "python3.12"], var.runtime)
    error_message = "Runtime must be one of: python3.9, python3.10, python3.11, python3.12."
  }
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30

  validation {
    condition     = var.timeout >= 3 && var.timeout <= 900
    error_message = "Timeout must be between 3 and 900 seconds."
  }
}

variable "memory_size" {
  description = "Lambda function memory in MB"
  type        = number
  default     = 256

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "Memory size must be between 128 and 10240 MB."
  }

  validation {
    condition     = var.memory_size % 64 == 0
    error_message = "Memory size must be a multiple of 64 MB."
  }
}

variable "max_file_size_mb" {
  description = "Maximum file size in MB for direct uploads"
  type        = number
  default     = 6

  validation {
    condition     = var.max_file_size_mb > 0 && var.max_file_size_mb <= 6
    error_message = "Max file size must be between 1 and 6 MB for direct uploads."
  }
}

variable "presigned_url_expiry" {
  description = "Presigned URL expiration time in seconds"
  type        = number
  default     = 3600

  validation {
    condition     = var.presigned_url_expiry >= 60 && var.presigned_url_expiry <= 604800
    error_message = "Presigned URL expiry must be between 60 seconds (1 min) and 604800 seconds (7 days)."
  }
}

variable "tags" {
  description = "Tags to apply to Lambda function"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[\\w\\s+=.:\\/@-]{1,128}$", k))])
    error_message = "Tag keys must be 1-128 characters and contain only letters, numbers, spaces, and +=.:/@- characters."
  }
}
