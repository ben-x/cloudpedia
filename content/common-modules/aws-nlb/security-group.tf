resource "aws_security_group" "main" {
  name_prefix = "${var.name}-sg"
  description = "Security group for ${var.name} applicaion load-balancer"
  vpc_id      = var.vpc.id

  tags = merge(var.tags, {
    Name = "${var.name}-sg"
  })
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each = var.listener_config

  description       = "Ingress rule for ${each.key}"
  from_port         = each.value.port
  protocol          = "tcp"
  security_group_id = aws_security_group.main.id
  to_port           = each.value.port
  type              = "ingress"
  cidr_blocks       = var.is_internal ? [var.vpc.cidr_block] : ["0.0.0.0/0"]
}
