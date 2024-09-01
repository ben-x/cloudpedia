resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    "Name" = "${local.vpc_name}-igw"
  })
}

resource "aws_eip" "main" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${local.vpc_name}-eip-az-${local.nat_az}"
    Description = "Routes internal traffic to the internet through public subnet in AZ ${local.nat_az}"
  })

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = module.public_subnet.subnets[local.nat_az].id

  tags = merge(var.tags, {
    Name = "${local.vpc_name}-nat-az-${local.nat_az}"
    Description = "Nat Gateway routes internal traffic to internet through public subnet in AZ ${local.nat_az}"
  })

  depends_on = [aws_internet_gateway.main]
}
