resource "aws_subnet" "main" {
  for_each = var.cidr_blocks

  availability_zone = local.subnet_az_mappings[each.key]
  cidr_block = each.value
  vpc_id = var.vpc.id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name}-${local.subnet_az_mappings[each.key]}"
    }
  )
}
