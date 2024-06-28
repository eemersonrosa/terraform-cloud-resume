# variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

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

variable "aliases" {
  description = "Aliases for the CloudFront distribution"
  type        = list(string)
  default     = ["resume.emersonrosa.com"]
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
  default     = "arn:aws:acm:us-east-1:909704688421:certificate/054d4ada-7fd0-475f-8fa6-c9de8fc0a739"
}

variable "price_class" {
  description = "Price class for the CloudFront distribution"
  type        = string
  default     = "PriceClass_100"
}

variable "zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
  default     = "Z08885102U9M21ZMYE1PS" # Replace with your Route53 hosted zone ID
}

variable "record_name" {
  description = "Name of the Route53 record"
  type        = string
  default     = "resume.emersonrosa.com"
}