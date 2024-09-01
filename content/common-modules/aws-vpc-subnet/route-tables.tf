resource "aws_route_table" "main" {
  for_each = aws_subnet.main

  vpc_id = var.vpc.id

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}-route-table"
    Description = "Route table for ${var.name}-${each.key} subnet"
  })
}

resource "aws_route_table_association" "main" {
  for_each = aws_subnet.main

  route_table_id = aws_route_table.main[each.key].id
  subnet_id = each.value.id
}
