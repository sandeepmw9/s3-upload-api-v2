# Main Terraform Configuration for S3 Upload API with Presigned URLs

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# S3 Bucket Module
module "s3_bucket" {
  source = "./modules/s3-bucket"

  bucket_name        = var.bucket_name
  enable_versioning  = var.enable_versioning
  enable_encryption  = var.enable_encryption
  tags               = merge(var.tags, {
    Name        = var.bucket_name
    Environment = var.environment
    Project     = var.project_name
  })
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  lambda_function_name = var.lambda_function_name
  s3_bucket_arn        = module.s3_bucket.bucket_arn
  tags                 = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}

# Lambda Module
module "lambda" {
  source = "./modules/lambda"

  function_name         = var.lambda_function_name
  s3_bucket_name        = module.s3_bucket.bucket_name
  lambda_role_arn       = module.iam.lambda_role_arn
  runtime               = "python3.11"
  timeout               = var.lambda_timeout
  memory_size           = var.lambda_memory_size
  max_file_size_mb      = var.max_file_size_mb
  presigned_url_expiry  = var.presigned_url_expiry

  tags                  = merge(var.tags, {
    Name        = var.lambda_function_name
    Environment = var.environment
    Project     = var.project_name
  })

  depends_on = [module.iam]
}

# API Gateway Module
module "api_gateway" {
  source = "./modules/api-gateway"

  api_name              = var.api_name
  lambda_invoke_arn     = module.lambda.function_invoke_arn
  lambda_function_name  = module.lambda.function_name
  stage_name            = var.api_stage_name
  enable_cors           = var.enable_cors
  allowed_origins       = var.allowed_origins
  tags                  = merge(var.tags, {
    Name        = var.api_name
    Environment = var.environment
    Project     = var.project_name
  })

  depends_on = [module.lambda]
}
