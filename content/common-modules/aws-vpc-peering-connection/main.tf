data "aws_caller_identity" "accepter" {
  provider = aws.accepter
}

resource "aws_vpc_peering_connection" "requester" {
  provider = aws.requester

  auto_accept   = false
  peer_owner_id = data.aws_caller_identity.accepter.account_id
  peer_region   = var.accepter.region
  peer_vpc_id   = var.accepter.vpc_id
  vpc_id        = var.requester.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-requester"
  })
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider = aws.accepter

  auto_accept               = true
  vpc_peering_connection_id = aws_vpc_peering_connection.requester.id

  tags = merge(var.tags, {
    Name = "${var.name}-accepter"
  })
}

resource "aws_vpc_peering_connection_options" "requester" {
  provider = aws.requester

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter.id

  requester {
    allow_remote_vpc_dns_resolution = var.allow_dns_resolution
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider = aws.accepter

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter.id

  accepter {
    allow_remote_vpc_dns_resolution = var.allow_dns_resolution
  }
}
