resource "aws_security_group" "main" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name}"
  vpc_id      = var.vpc.id

  tags = merge(var.tags, {
    Name = "${var.name}-sg"
  })
}

resource "aws_security_group_rule" "allow_all_egress" {
  description       = "Allow all outbound requests from the resources"
  from_port         = 0
  protocol          = "all"
  security_group_id = aws_security_group.main.id
  to_port           = 65535
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each = var.ingress_rules

  description       = "Ingress rule for ${each.key}"
  from_port         = each.value.source_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.main.id
  to_port           = each.value.destination_port
  type              = "ingress"
  cidr_blocks       = each.value.cidr_blocks
}
