# variables.tf
variable "site_domain" {
  type = string
}

variable "CLOUDFLARE_API_TOKEN" {
  type      = string
  sensitive = true
}

variable "common_tags" {
  type        = map(any)
  description = "Map of common tags for all resources."

  validation {
    condition     = can(regex("^[A-Za-z]+ [A-Za-z]+$", var.common_tags["owner"]))
    error_message = "The 'owner' value in 'common_tags' must be in the format 'Firstname Lastname'."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", var.common_tags["created-by"]))
    error_message = "The 'created-by' value in 'common_tags' must follow an email format."
  }

  validation {
    condition     = can(regex("^(prd|tst|dev|int|dmo|qa|qam|qab|ppd|dbg|uat)$", var.common_tags["env"]))
    error_message = "The 'env' value in 'common_tags' must be one of prd,tst,dev,int,dmo,qa,qam,qab,ppd,dbg,uat."
  }

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+-[0-9]+$", var.common_tags["region"]))
    error_message = "The 'region' value in 'common_tags' should follow the standard AWS Region Identifiers."
  }
}