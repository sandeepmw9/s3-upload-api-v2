# Lambda Module
# Creates Lambda function for processing file uploads and generating presigned URLs

# Package the Lambda function code into a zip file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Create the Lambda function
resource "aws_lambda_function" "upload_handler" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.function_name
  role             = var.lambda_role_arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size

  environment {
    variables = {
      S3_BUCKET_NAME          = var.s3_bucket_name
      MAX_FILE_SIZE_MB        = var.max_file_size_mb
      PRESIGNED_URL_EXPIRY    = var.presigned_url_expiry
    }
  }

  tags = var.tags
}
