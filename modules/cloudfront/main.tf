# modules/cloudfront/main.tf
resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = var.bucket_id
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name              = var.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
    origin_id                = var.bucket_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "My CloudFront Distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    cache_policy_id  = "527d7b1a-4b9b-44f7-964a-0a58fb3082ec"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_id

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

  aliases = ["resume.emersonrosa.com"]

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:909704688421:certificate/054d4ada-7fd0-475f-8fa6-c9de8fc0a739"
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

  price_class = "PriceClass_100"

  tags = {
    Name = "Cloud Resume Distribution"
  }
}