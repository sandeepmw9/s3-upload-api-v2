# Upload Methods Comparison

## Method 1: Direct Upload via API Gateway (Original)

### Flow
```
Browser → API Gateway → Lambda → S3
```

### Pros
- Simple implementation
- Single endpoint
- File validation in Lambda

### Cons
- **6MB limit** (Lambda payload)
- Base64 encoding overhead (~33% larger)
- Higher Lambda costs for large files
- Slower for large files

### Best For
- Small files (< 5MB)
- When you need server-side validation
- Simple integrations

---

## Method 2: Presigned URL Upload (Enhanced)

### Flow
```
1. Browser → API Gateway → Lambda (get presigned URL)
2. Browser → S3 (direct upload)
```

### Pros
- **5GB limit** (S3 multipart upload)
- No base64 encoding needed
- Direct browser-to-S3 (faster)
- Lower Lambda costs
- Progress tracking in browser
- Works with large files

### Cons
- Two-step process
- Validation happens after upload
- Slightly more complex client code

### Best For
- Large files (> 6MB)
- Browser uploads
- Mobile apps
- When upload speed matters

---

## File Size Limits Summary

| Component | Limit | Notes |
|-----------|-------|-------|
| API Gateway payload | 10MB | Hard limit |
| Lambda synchronous | 6MB | Hard limit |
| Lambda async | 256KB | Event payload |
| S3 single PUT | 5GB | Single operation |
| S3 multipart | 5TB | Multiple parts |
| Presigned URL | 5GB | Single PUT |

---

## Cost Comparison (1000 uploads of 50MB files)

### Direct Upload (if it worked)
- API Gateway: $3.50 (1000 requests)
- Lambda: $20.00 (50MB × 1000 × duration)
- S3 PUT: $0.005 (1000 requests)
- **Total: ~$23.50**

### Presigned URL
- API Gateway: $3.50 (1000 requests)
- Lambda: $0.20 (minimal processing)
- S3 PUT: $0.005 (1000 requests)
- **Total: ~$3.70**

**Savings: 84% cheaper for large files!**

---

## When to Use Each Method

### Use Direct Upload When:
- Files are < 5MB
- You need immediate validation
- Simple client implementation needed
- Server-side processing required before storage

### Use Presigned URL When:
- Files are > 6MB
- Uploading from browsers
- Cost optimization matters
- Upload speed is important
- Need progress tracking
