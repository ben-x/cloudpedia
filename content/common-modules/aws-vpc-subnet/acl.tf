resource "aws_network_acl" "main" {
  vpc_id      = var.vpc.id
  subnet_ids  = [for subnet in aws_subnet.main: subnet.id]

  tags = merge(var.tags, {
    Name = "${var.name}-acl"
    Description = "ACL for ${var.name}"
  })
}
