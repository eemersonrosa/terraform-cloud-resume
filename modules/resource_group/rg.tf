locals {
  tag_filters = [
    for key, value in var.common_tags : {
      Key    = key
      Values = [value]
    }
  ]
}

resource "aws_resourcegroups_group" "example" {
  name = "cloud-resume-rg"

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]
      TagFilters          = local.tag_filters
    })
  }
}