# modules/s3_bucket/main.tf
resource "random_integer" "random_number" {
  min = 1
  max = 1000
}

resource "random_string" "random_string" {
  length  = 8
  special = false
  lower   = true
  upper = false
}

resource "random_string" "random_string2" {
  length  = 8
  special = false
  lower   = true
  upper = false
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = "emerson-${random_integer.random_number.result}-resume-${random_string.random_string.result}-${random_string.random_string2.result}"

  tags = {
    Name        = "Cloud-Resume"
    Environment = "Prod"
  }
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