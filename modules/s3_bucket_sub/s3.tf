# modules/s3_bucket/main.tf

resource "aws_s3_bucket" "my_bucket_sub" {
  bucket = "www.${var.site_domain}"

  tags = merge(var.common_tags, {
  })
}

resource "aws_s3_bucket_public_access_block" "my_bucket_pub_block_sub" {
  bucket = aws_s3_bucket.my_bucket_sub.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "my_bucket_web_config_sub" {
  bucket = aws_s3_bucket.my_bucket_sub.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "my_bucket_ownership_sub" {
  bucket = aws_s3_bucket.my_bucket_sub.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "my_bucket_acl_sub" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my_bucket_ownership_sub,
    aws_s3_bucket_public_access_block.my_bucket_pub_block_sub
  ]
  bucket = aws_s3_bucket.my_bucket_sub.id
  acl    = "private"
}

# Objects are readable only through Cloudflare (its published IP ranges);
# the bucket ACL stays private so the bucket cannot be listed directly.
resource "aws_s3_bucket_policy" "my_bucket_policy_sub" {
  bucket = aws_s3_bucket.my_bucket_sub.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource = [
          "${aws_s3_bucket.my_bucket_sub.arn}/*",
        ],
        Condition = {
          IpAddress = {
            "aws:SourceIp" = [
              "173.245.48.0/20",
              "103.21.244.0/22",
              "103.22.200.0/22",
              "103.31.4.0/22",
              "141.101.64.0/18",
              "108.162.192.0/18",
              "190.93.240.0/20",
              "188.114.96.0/20",
              "197.234.240.0/22",
              "198.41.128.0/17",
              "162.158.0.0/15",
              "104.16.0.0/13",
              "104.24.0.0/14",
              "172.64.0.0/13",
              "131.0.72.0/22",
              "2400:cb00::/32",
              "2606:4700::/32",
              "2803:f800::/32",
              "2405:b500::/32",
              "2405:8100::/32",
              "2a06:98c0::/29",
              "2c0f:f248::/32"
            ]
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.my_bucket_pub_block_sub]
}