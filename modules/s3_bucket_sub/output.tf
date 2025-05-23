output "target_s3_bucket_sub" {
  value = aws_s3_bucket.my_bucket_sub.bucket
}

output "bucket_id" {
  value = aws_s3_bucket.my_bucket_sub.id
}

output "bucket_arn" {
  value = aws_s3_bucket.my_bucket_sub.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.my_bucket_sub.bucket_regional_domain_name
}

output "s3_web_endpoint_sub" {
  value = aws_s3_bucket_website_configuration.my_bucket_web_config_sub.website_endpoint
}