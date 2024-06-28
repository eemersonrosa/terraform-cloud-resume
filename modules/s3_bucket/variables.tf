# modules/s3_bucket/variables.tf
variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
  default     = "emerson"
}

variable "environment" {
  description = "Environment for the S3 bucket"
  type        = string
  default     = "Prod"
}

variable "cloudfront_arn" {
  description = "cloudfront ARN"
  type        = string
}

variable "cloudfront_distribution_resource" {
  description = "cloudfront resource"
  type        = string
}