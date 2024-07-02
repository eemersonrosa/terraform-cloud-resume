# variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Environment for the S3 bucket"
  type        = string
}

variable "aliases" {
  description = "Aliases for the CloudFront distribution"
  type        = list(string)
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
}

variable "price_class" {
  description = "Price class for the CloudFront distribution"
  type        = string
}

variable "zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "record_name" {
  description = "Name of the Route53 record"
  type        = string
}

variable "cache_policy_id" {
  description = "Cache Policy ID previously created"
  type        = string
}