# S3 Upload API with Presigned URLs

Enhanced version supporting large file uploads and browser-based uploads.

## Features

- **Presigned URLs**: Direct browser-to-S3 uploads (up to 5GB)
- **Dual Mode**: GET for presigned URL, POST for small files
- **CORS Enabled**: Works from any browser
- **Progress Tracking**: Real-time upload progress
- **Multiple File Types**: PDF, JPEG, PNG support

## Architecture Comparison

### Original (Limited to 6MB)
```
Browser → API Gateway → Lambda → S3
         (10MB limit)  (6MB limit)
```

### Enhanced (Up to 5GB)
```
Browser → API Gateway → Lambda (generates presigned URL)
Browser → S3 (direct upload with presigned URL)
```

## Usage

### 1. Get Presigned URL (for large files)

```bash
curl "https://YOUR_API/prod/upload?filename=large.pdf&contentType=application/pdf&maxSize=104857600"
```

Response:
```json
{
  "uploadUrl": "https://bucket.s3.amazonaws.com/",
  "fields": {
    "key": "uploads/20240220_123456_abc123.pdf",
    "Content-Type": "application/pdf",
    ...
  },
  "key": "uploads/20240220_123456_abc123.pdf",
  "expiresIn": 3600
}
```

### 2. Upload to S3 using presigned URL

```javascript
const formData = new FormData();
Object.keys(fields).forEach(key => formData.append(key, fields[key]));
formData.append('file', fileBlob);

await fetch(uploadUrl, {
  method: 'POST',
  body: formData
});
```

### 3. Browser Upload (see browser-upload-example.html)

```html
<input type="file" id="fileInput">
<button onclick="uploadFile()">Upload</button>
```

## File Size Limits

| Method | Max Size | Use Case |
|--------|----------|----------|
| POST (direct) | 6MB | Small files, simple integration |
| GET (presigned) | 5GB | Large files, browser uploads |

## Configuration Changes

### S3 Bucket CORS (add to modules/s3-bucket/main.tf)

```hcl
resource "aws_s3_bucket_cors_configuration" "pdf_storage" {
  bucket = aws_s3_bucket.pdf_storage.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]  # Restrict in production
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
```

## Deployment

Same as original:
```bash
cd s3-upload-api-presigned
terraform init
terraform apply
```

## Security Considerations

1. **Presigned URL expiration**: Default 1 hour
2. **File size limits**: Enforced in presigned URL conditions
3. **Content-Type validation**: Only allowed types accepted
4. **CORS origins**: Set to `*` for demo, restrict in production

## Browser Example

Open `browser-upload-example.html` and update `API_ENDPOINT` with your API Gateway URL.
