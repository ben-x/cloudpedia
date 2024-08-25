resource "aws_route" "private_subnet_to_external_route" {
  for_each = module.private_subnet.route_tables

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
  route_table_id         = each.value.id
}

resource "aws_route" "public_subnet_to_internet_route" {
  for_each = module.public_subnet.route_tables

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  route_table_id         = each.value.id
}

resource "aws_network_acl_rule" "egress_private_subnet" {
  for_each = {
    100 = {
      cidr_block     = "0.0.0.0/0"
      protocol       = "all"
      rule_action    = "allow"
      from_port      = 0
      to_port        = 0
    }
  }

  cidr_block     = each.value.cidr_block
  egress         = true
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  network_acl_id = module.private_subnet.acl_id
  rule_number    = each.key
}

resource "aws_network_acl_rule" "ingress_private_subnet" {
  for_each = {
    100 = {
      cidr_block     = var.cidr_blocks.vpc
      protocol       = "all"
      rule_action    = "allow"
      from_port      = 0
      to_port        = 0
    }
    200 = {
      cidr_block     = "0.0.0.0/0"
      protocol       = "tcp"
      rule_action    = "allow"
      from_port      = 1024
      to_port        = 65535
    }
    300 = {
      cidr_block     = "0.0.0.0/0"
      protocol       = "all"
      rule_action    = "allow"
      from_port      = 0
      to_port        = 0
    }
  }

  cidr_block     = each.value.cidr_block
  egress         = false
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  network_acl_id = module.private_subnet.acl_id
  rule_number    = each.key
}

resource "aws_network_acl_rule" "egress_public_subnet" {
  for_each = {
    100 = {
      cidr_block     = "0.0.0.0/0"
      protocol       = "all"
      rule_action    = "allow"
      from_port      = 0
      to_port        = 0
    }
  }

  cidr_block     = each.value.cidr_block
  egress         = true
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  network_acl_id = module.public_subnet.acl_id
  rule_number    = each.key
}

resource "aws_network_acl_rule" "ingress_public_subnet" {
  for_each = {
    100 = {
      cidr_block     = "0.0.0.0/0"
      protocol       = "all"
      rule_action    = "allow"
      from_port      = 0
      to_port        = 0
    }
  }

  cidr_block     = each.value.cidr_block
  egress         = false
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  network_acl_id = module.public_subnet.acl_id
  rule_number    = each.key
}
