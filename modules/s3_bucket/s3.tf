# modules/s3_bucket/main.tf
resource "random_string" "random_string_1" {
  length  = 4
  special = false
  lower   = true
  upper = false
}

resource "random_string" "random_string_2" {
  length  = 4
  special = false
  lower   = true
  upper = false
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.bucket_prefix}-resume-${random_string.random_string_1.result}-${random_string.random_string_2.result}"

  tags = merge(var.common_tags, {
  })
}

resource "aws_s3_bucket_ownership_controls" "my_bucket_ownership" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.my_bucket_ownership]
  bucket     = aws_s3_bucket.my_bucket.id
  acl        = "private"
}

resource "aws_s3_bucket_public_access_block" "my_bucket_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Update S3 bucket policy to allow access from CloudFront
resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontAccess",
        Effect = "Allow",
        Principal : {
          Service : "cloudfront.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.my_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${var.cloudfront_arn}"
          }
        }
      }
    ]
  })

  depends_on = [var.cloudfront_distribution_resource]
}