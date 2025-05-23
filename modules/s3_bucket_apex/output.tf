output "bucket_id" {
  value = aws_s3_bucket.my_bucket_apex.id
}

output "bucket_arn" {
  value = aws_s3_bucket.my_bucket_apex.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.my_bucket_apex.bucket_regional_domain_name
}

output "s3_web_endpoint_apex" {
  value = aws_s3_bucket_website_configuration.my_bucket_web_config_apex.website_endpoint
}