data "aws_regions" "all" {
  all_regions = var.query_all_regions
}

data "aws_region" "one" {
  #  for_each = data.aws_regions.all.names
  for_each = { for k, v in data.aws_regions.all.names : k => v if !contains(["ap-northeast-3","ap-southeast-4"], k) }

  name = each.value
}

locals {
  # Note: Adding more regions and local zones. Copied from https://github.com/powdahound/ec2instances.info/blob/master/ec2.py
  all_aws_regions = merge({ for k, v in data.aws_region.one : replace(v.description, "Europe", "EU") => k }, {
    "Asia Pacific (Osaka-Local)" = "ap-northeast-3"
    "Asia Pacific (Melbourne)"   = "ap-southeast-4"
    "US West (Los Angeles)"      = "us-west-2"
  })
}
