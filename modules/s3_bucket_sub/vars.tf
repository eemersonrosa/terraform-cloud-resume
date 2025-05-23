# modules/s3_bucket/variables.tf
variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Environment for the S3 bucket"
  type        = string
}

variable "common_tags" {
  type        = map(any)
  description = "Map of common tags."
}

variable "site_domain" {
  type = string
}