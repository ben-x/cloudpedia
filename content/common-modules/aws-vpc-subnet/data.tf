locals {
  subnet_az_mappings = {
    for key, val in keys(var.cidr_blocks) : val => data.aws_availability_zones.available.names[key]
  }
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name = "region-name"
    values = [var.aws_region]
  }
}
