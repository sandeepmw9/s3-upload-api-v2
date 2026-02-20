# Variables for API Gateway Module

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string

  validation {
    condition     = length(var.api_name) >= 1 && length(var.api_name) <= 128
    error_message = "API name must be between 1 and 128 characters."
  }
}

variable "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:apigateway:[a-z0-9-]+:lambda:path/", var.lambda_invoke_arn))
    error_message = "Must be a valid Lambda invoke ARN for API Gateway."
  }
}

variable "lambda_function_name" {
  description = "Name of the Lambda function for permissions"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]{1,64}$", var.lambda_function_name))
    error_message = "Function name must be 1-64 characters, alphanumeric, hyphens, and underscores only."
  }
}

variable "stage_name" {
  description = "Name of the API Gateway deployment stage"
  type        = string
  default     = "prod"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]{1,128}$", var.stage_name))
    error_message = "Stage name must be 1-128 characters, alphanumeric, hyphens, and underscores only."
  }
}

variable "enable_cors" {
  description = "Enable CORS for the API (required for browser uploads)"
  type        = bool
  default     = true
}

variable "allowed_origins" {
  description = "List of allowed origins for CORS (use ['*'] for all origins)"
  type        = list(string)
  default     = ["*"]

  validation {
    condition     = length(var.allowed_origins) > 0
    error_message = "At least one allowed origin must be specified."
  }
}

variable "binary_media_types" {
  description = "List of binary media types supported by the API"
  type        = list(string)
  default     = ["application/pdf", "application/octet-stream", "image/jpeg", "image/png"]

  validation {
    condition     = length(var.binary_media_types) > 0
    error_message = "At least one binary media type must be specified."
  }
}

variable "throttle_burst_limit" {
  description = "API Gateway throttle burst limit"
  type        = number
  default     = 5000

  validation {
    condition     = var.throttle_burst_limit >= 0 && var.throttle_burst_limit <= 10000
    error_message = "Throttle burst limit must be between 0 and 10000."
  }
}

variable "throttle_rate_limit" {
  description = "API Gateway throttle rate limit (requests per second)"
  type        = number
  default     = 10000

  validation {
    condition     = var.throttle_rate_limit >= 0 && var.throttle_rate_limit <= 20000
    error_message = "Throttle rate limit must be between 0 and 20000."
  }
}

variable "tags" {
  description = "Tags to apply to API Gateway resources"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[\\w\\s+=.:\\/@-]{1,128}$", k))])
    error_message = "Tag keys must be 1-128 characters and contain only letters, numbers, spaces, and +=.:/@- characters."
  }
}
