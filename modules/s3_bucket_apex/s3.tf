# modules/s3_bucket_apex/main.tf

resource "aws_s3_bucket" "my_bucket_apex" {
  bucket = var.site_domain

  tags = merge(var.common_tags, {
  })
}

resource "aws_s3_bucket_public_access_block" "my_bucket_pub_block_apex" {
  bucket = aws_s3_bucket.my_bucket_apex.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "my_bucket_web_config_apex" {
  bucket = aws_s3_bucket.my_bucket_apex.id

  redirect_all_requests_to {
    host_name = var.target_s3_bucket_sub
    protocol  = "https"
  }
}

resource "aws_s3_bucket_ownership_controls" "my_bucket_ownership_apex" {
  bucket = aws_s3_bucket.my_bucket_apex.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "my_bucket_acl_apex" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my_bucket_ownership_apex,
    aws_s3_bucket_public_access_block.my_bucket_pub_block_apex
  ]
  bucket = aws_s3_bucket.my_bucket_apex.id
  acl    = "private"
}
