terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.CLOUDFLARE_API_TOKEN
}

# Configure backend
terraform {
  backend "s3" {
    bucket  = "emerson-terraform-f3r2dfj"
    key     = "emerson-resume-tf.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "resource_group" {
  source      = "./modules/resource_group"
  common_tags = var.common_tags
}

module "s3_bucket_sub" {
  source      = "./modules/s3_bucket_sub"
  common_tags = var.common_tags
  site_domain = var.site_domain
}

module "s3_bucket_apex" {
  source               = "./modules/s3_bucket_apex"
  common_tags          = var.common_tags
  site_domain          = var.site_domain
  target_s3_bucket_sub = module.s3_bucket_sub.target_s3_bucket_sub
}

module "cloudflare" {
  source               = "./modules/cloudflare"
  site_domain          = var.site_domain
  s3_web_endpoint_apex = module.s3_bucket_apex.s3_web_endpoint_apex
  s3_web_endpoint_sub  = module.s3_bucket_sub.s3_web_endpoint_sub
}

# Upload a local folder and its contents to the S3 bucket
resource "aws_s3_object" "folder_upload" {
  for_each = fileset("cloud-resume/website", "**/*")

  bucket = module.s3_bucket_sub.bucket_id
  key    = each.value
  source = "cloud-resume/website/${each.value}"
  etag   = filemd5("cloud-resume/website/${each.value}")
}