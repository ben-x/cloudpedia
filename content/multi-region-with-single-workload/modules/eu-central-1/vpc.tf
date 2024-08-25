resource "aws_vpc" "main" {
  cidr_block           = var.cidr_blocks.vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      "Name" = local.vpc_name
    }
  )
}

module "private_subnet" {
  source = "../../../common-modules/aws-vpc-subnet"

  aws_region  = var.aws_region
  cidr_blocks = var.cidr_blocks.private_subnet
  name        = "private-subnet"
  tags        = var.tags
  vpc         = aws_vpc.main
}

module "public_subnet" {
  source = "../../../common-modules/aws-vpc-subnet"

  aws_region  = var.aws_region
  cidr_blocks = var.cidr_blocks.public_subnet
  name        = "public-subnet"
  tags        = var.tags
  vpc         = aws_vpc.main
}
