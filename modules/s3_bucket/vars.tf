# modules/s3_bucket/variables.tf
variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Environment for the S3 bucket"
  type        = string
}

variable "cloudfront_arn" {
  description = "cloudfront ARN"
  type        = string
}

variable "cloudfront_distribution_resource" {
  description = "cloudfront resource"
  type        = string
}

variable "common_tags" {
  type        = map(any)
  description = "Map of common tags."
}