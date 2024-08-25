module "global_upstream" {
  source = "../modules/global-upstream"

  providers = {
    aws.ca-west-1    = aws.ca-west-1
    aws.eu-central-1 = aws.eu-central-1
  }

  ca_west_1 = {
    dns_config = local.ca_west_1.dns_config
  }

  eu_central_1 = {
    dns_config = local.eu_central_1.dns_config
  }

  tags = merge(local.default_tags, {
    module = "global-upstream"
  })
}

module "ca_west_1" {
  source = "../modules/ca-west-1"

  providers = {
    aws = aws.ca-west-1
  }

  aws_region = "ca-west-1"
  cidr_blocks = local.ca_west_1.cidr_blocks
  dns_config = module.global_upstream.domain_config.ca_west_1

  tags = merge(local.default_tags, {
    module = "ca-west-1"
  })
}

module "eu_central_1" {
  source = "../modules/eu-central-1"

  providers = {
    aws = aws.eu-central-1
  }

  aws_region = "eu-central-1"

  cidr_blocks = local.eu_central_1.cidr_blocks
  dns_config = module.global_upstream.domain_config.eu_central_1

  tags = merge(local.default_tags, {
    module = "eu-central-1"
  })
}

module "global_downstream" {
  source = "../modules/global-downstream"

  providers = {
    aws.ca-west-1    = aws.ca-west-1
    aws.eu-central-1 = aws.eu-central-1
  }

  ca_west_1 = {
    aws_region = "ca-west-1"
    vpc = {
      main = module.ca_west_1.vpc
    }
    subnets = {
      public_subnets = module.ca_west_1.public_subnets
    }
  }

  eu_central_1 = {
    aws_region = "eu-central-1"
    vpc = {
      main = module.eu_central_1.vpc
    }
    subnets = {
      public_subnets = module.eu_central_1.public_subnets
    }
  }

  tags = merge(local.default_tags, {
    module = "global-downstream"
  })
}
