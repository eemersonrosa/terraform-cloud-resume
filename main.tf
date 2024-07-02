terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Configure backend
terraform {
  backend "s3" {
    bucket  = "emerson-terraform-bucket-2024-11-rosa"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "s3_bucket" {
  source                           = "./modules/s3_bucket"
  bucket_prefix                    = var.bucket_prefix
  environment                      = var.environment
  cloudfront_arn                   = module.cloudfront.cloudfront_arn
  cloudfront_distribution_resource = module.cloudfront.cloudfront_distribution_id
}

module "cloudfront" {
  source              = "./modules/cloudfront"
  bucket_id           = module.s3_bucket.bucket_id
  bucket_domain_name  = module.s3_bucket.bucket_domain_name
  aliases             = var.aliases
  acm_certificate_arn = var.acm_certificate_arn
  price_class         = var.price_class
  cache_policy_id     = var.cache_policy_id
}

module "route53" {
  source                    = "./modules/route53"
  cloudfront_domain_name    = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_distribution_id
  zone_id                   = var.zone_id
  record_name               = var.record_name
}

# Data source to get the current AWS account ID
data "aws_caller_identity" "current" {}

# Upload a local folder and its contents to the S3 bucket
resource "aws_s3_object" "folder_upload" {
  for_each = fileset("cloud-resume/website", "**/*")

  bucket = module.s3_bucket.bucket_id
  key    = each.value
  source = "cloud-resume/website/${each.value}"
  etag   = filemd5("cloud-resume/website/${each.value}")
}
