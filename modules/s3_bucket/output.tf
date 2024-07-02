output "bucket_id" {
  value = aws_s3_bucket.my_bucket.id
  sensitive = true
}

output "bucket_arn" {
  value = aws_s3_bucket.my_bucket.arn
  sensitive = true
}

output "bucket_domain_name" {
  value = aws_s3_bucket.my_bucket.bucket_regional_domain_name
  sensitive = true
}