# modules/cloudfront/variables.tf
variable "bucket_id" {
  description = "ID of the S3 bucket"
  type        = string
}

variable "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  type        = string
}

variable "aliases" {
  description = "Aliases for the CloudFront distribution"
  type        = list(string)
  default     = ["resume.emersonrosa.com"]
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
}

variable "price_class" {
  description = "Price class for the CloudFront distribution"
  type        = string
  default     = "PriceClass_100"
}
