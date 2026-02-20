import json
import boto3
import os
from datetime import datetime
import uuid

s3_client = boto3.client('s3')


def lambda_handler(event, context):
    """
    Generate presigned URL for direct S3 upload or handle small file uploads.
    
    Supports two modes:
    1. GET request: Returns presigned URL for browser upload
    2. POST request: Direct upload for small files (< 6MB)
    """
    
    try:
        bucket_name = os.environ.get('S3_BUCKET_NAME')
        if not bucket_name:
            print("ERROR: S3_BUCKET_NAME environment variable not set")
            return error_response(500, 'Internal server error')
        
        http_method = event.get('httpMethod', 'POST')
        
        # Mode 1: Generate presigned URL for large file uploads
        if http_method == 'GET':
            return generate_presigned_url(bucket_name, event)
        
        # Mode 2: Direct upload for small files
        elif http_method == 'POST':
            return handle_direct_upload(bucket_name, event)
        
        else:
            return error_response(405, 'Method not allowed')
            
    except Exception as e:
        print(f"ERROR: Unexpected error: {str(e)}")
        return error_response(500, 'Internal server error')


def generate_presigned_url(bucket_name, event):
    """Generate presigned URL for direct S3 upload from browser."""
    try:
        # Parse query parameters
        params = event.get('queryStringParameters') or {}
        filename = params.get('filename', 'document.pdf')
        content_type = params.get('contentType', 'application/pdf')
        max_size = int(params.get('maxSize', 100 * 1024 * 1024))  # Default 100MB
        
        # Validate content type
        allowed_types = ['application/pdf', 'image/jpeg', 'image/png']
        if content_type not in allowed_types:
            return error_response(400, f'Content type must be one of: {", ".join(allowed_types)}')
        
        # Generate unique S3 key
        timestamp = datetime.utcnow().strftime('%Y%m%d_%H%M%S')
        unique_id = str(uuid.uuid4())[:8]
        file_extension = filename.split('.')[-1] if '.' in filename else 'pdf'
        s3_key = f"uploads/{timestamp}_{unique_id}.{file_extension}"
        
        # Generate presigned POST URL (more secure for uploads)
        presigned_post = s3_client.generate_presigned_post(
            Bucket=bucket_name,
            Key=s3_key,
            Fields={
                'Content-Type': content_type,
                'x-amz-server-side-encryption': 'AES256'
            },
            Conditions=[
                {'Content-Type': content_type},
                ['content-length-range', 1, max_size],
                {'x-amz-server-side-encryption': 'AES256'}
            ],
            ExpiresIn=3600  # URL valid for 1 hour
        )
        
        print(f"SUCCESS: Generated presigned URL for {s3_key}")
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'uploadUrl': presigned_post['url'],
                'fields': presigned_post['fields'],
                'key': s3_key,
                'bucket': bucket_name,
                'expiresIn': 3600
            })
        }
        
    except Exception as e:
        print(f"ERROR: Failed to generate presigned URL: {str(e)}")
        return error_response(500, 'Failed to generate upload URL')



def handle_direct_upload(bucket_name, event):
    """Handle direct upload for small files through API Gateway."""
    try:
        import base64
        
        # Get file content from request body
        if event.get('isBase64Encoded', False):
            file_content = base64.b64decode(event['body'])
        else:
            return error_response(400, 'File must be base64 encoded')
        
        # Validate file size (6MB limit for Lambda)
        file_size = len(file_content)
        max_size = 6 * 1024 * 1024  # 6MB
        if file_size > max_size:
            return error_response(413, 'File too large. Use presigned URL for files > 6MB')
        
        # Validate PDF format
        if not file_content.startswith(b'%PDF'):
            return error_response(400, 'File is not a valid PDF')
        
        # Generate unique filename
        timestamp = datetime.utcnow().strftime('%Y%m%d_%H%M%S')
        unique_id = str(uuid.uuid4())[:8]
        filename = f"uploads/{timestamp}_{unique_id}.pdf"
        
        # Upload to S3
        s3_client.put_object(
            Bucket=bucket_name,
            Key=filename,
            Body=file_content,
            ContentType='application/pdf',
            ServerSideEncryption='AES256'
        )
        
        print(f"SUCCESS: File uploaded to s3://{bucket_name}/{filename}")
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'message': 'File uploaded successfully',
                'filename': filename,
                'bucket': bucket_name,
                'size': file_size
            })
        }
        
    except Exception as e:
        print(f"ERROR: Upload failed: {str(e)}")
        return error_response(500, 'Upload failed')


def error_response(status_code, message):
    """Generate error response."""
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({'error': message})
    }
