terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "emerson-terraform-bucket-2024-11-rosa"
    key     = "terraform.tfstate"
    region  = "us-east-1" # Replace with your bucket's region
    encrypt = true
  }
}

# Generate a random 3-digit number
resource "random_integer" "random_bucket_number" {
  min = 100
  max = 999
}

# Create S3 bucket with a random 3-digit number
resource "aws_s3_bucket" "my_bucket" {
  bucket = "emerson-${random_integer.random_bucket_number.result}-cloud-resume-2024"

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

# Block public access
resource "aws_s3_bucket_public_access_block" "my_bucket_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = aws_s3_bucket.my_bucket.id
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name              = aws_s3_bucket.my_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
    origin_id                = aws_s3_bucket.my_bucket.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "My CloudFront Distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    cache_policy_id  = "527d7b1a-4b9b-44f7-964a-0a58fb3082ec"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.my_bucket.id

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = ["test.emersonrosa.com"]

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:909704688421:certificate/054d4ada-7fd0-475f-8fa6-c9de8fc0a739"
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

  price_class = "PriceClass_100"

  tags = {
    Name = "Cloud Resume Distrubution"
  }
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
            "AWS:SourceArn" = "${aws_cloudfront_distribution.my_distribution.arn}"
          }
        }
      }
    ]
  })

  depends_on = [aws_cloudfront_distribution.my_distribution]
}

# Data source to get the current AWS account ID
data "aws_caller_identity" "current" {}

# Create Route53 record
resource "aws_route53_record" "my_record" {
  zone_id = "Z08885102U9M21ZMYE1PS" # Replace with your Route53 hosted zone ID
  name    = "test.emersonrosa.com"  # Replace with your desired subdomain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.my_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.my_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# Output the CloudFront distribution domain name
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.my_distribution.domain_name
}

# Upload a local folder and its contents to the S3 bucket
resource "aws_s3_object" "folder_upload" {
  for_each = fileset("cloud-resume/website", "**/*")

  bucket = aws_s3_bucket.my_bucket.bucket
  key    = each.value
  source = "/cloud-resume/website/${each.value}"
  # etag makes the file update when it changes;
  etag = filemd5("cloud-resume/website/${each.value}")
}