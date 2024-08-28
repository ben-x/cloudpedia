module "vpc_peering_ca_west_1_eu_central_1" {
  source = "../../../common-modules/aws-vpc-peering-connection"

  providers = {
    aws.requester = aws.eu-central-1
    aws.accepter  = aws.ca-west-1
  }

  accepter = {
    region = var.ca_west_1.aws_region
    vpc_id = var.ca_west_1.vpc.main.id
  }

  allow_dns_resolution = true
  name                 = "ca-west-1-eu-central-1-vpc-peering"

  requester = {
    region = var.eu_central_1.aws_region
    vpc_id = var.eu_central_1.vpc.main.id
  }

  tags = var.tags
}

resource "aws_route" "ca_west_1_to_eu_central_1" {
  provider = aws.ca-west-1

  for_each = var.ca_west_1.subnets.private_subnets.route_tables

  destination_cidr_block = var.eu_central_1.vpc.main.cidr_block
  vpc_peering_connection_id = module.vpc_peering_ca_west_1_eu_central_1.aws_vpc_peering_connection_id
  route_table_id         = each.value.id
}

resource "aws_route" "eu_central_1_to_ca_west_1" {
  provider = aws.eu-central-1

  for_each = var.eu_central_1.subnets.public_subnets.route_tables

  destination_cidr_block = var.ca_west_1.vpc.main.cidr_block
  vpc_peering_connection_id = module.vpc_peering_ca_west_1_eu_central_1.aws_vpc_peering_connection_id
  route_table_id         = each.value.id
}
