output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.my_distribution.hosted_zone_id
  sensitive = true
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.my_distribution.domain_name
  sensitive = true
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.my_distribution.arn
  sensitive = true
}