# modules/s3_bucket/variables.tf
variable "common_tags" {
  type        = map(any)
  description = "Map of common tags."
}

variable "site_domain" {
  type = string
}

variable "target_s3_bucket_sub" {
  type = string
}