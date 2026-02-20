# Variables for S3 Bucket Module

variable "bucket_name" {
  description = "Name of the S3 bucket for file storage (must be globally unique)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be 3-63 characters, lowercase letters, numbers, and hyphens only."
  }

  validation {
    condition     = !can(regex("^xn--", var.bucket_name))
    error_message = "Bucket name cannot start with 'xn--'."
  }

  validation {
    condition     = !can(regex("\\.\\.|\\.\\-|\\-\\.", var.bucket_name))
    error_message = "Bucket name cannot contain consecutive periods, period-dash, or dash-period."
  }
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable server-side encryption (AES256)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[\\w\\s+=.:\\/@-]{1,128}$", k))])
    error_message = "Tag keys must be 1-128 characters and contain only letters, numbers, spaces, and +=.:/@- characters."
  }
}
