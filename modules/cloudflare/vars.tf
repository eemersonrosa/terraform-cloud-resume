# modules/cloudflare/variables.tf
variable "site_domain" {
  type = string
}

variable "s3_web_endpoint_apex" {
  type = string
}

variable "s3_web_endpoint_sub" {
  type = string
}