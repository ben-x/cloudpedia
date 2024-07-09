output "acl_id" {
  value = aws_network_acl.main.id
}

output "subnets" {
  value = {
    for az, subnet in aws_subnet.main: az => {
      arn        = subnet.arn
      id         = subnet.id
      cidr_block = subnet.cidr_block
    }
  }
}

output "route_tables" {
  value = {
    for az, route_table in aws_route_table.main: az => {
      arn        = route_table.arn
      id         = route_table.id
    }
  }
}
