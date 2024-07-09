resource "aws_lb" "main" {
  name                             = var.name
  internal                         = var.is_internal
  load_balancer_type               = "network"
  security_groups                  = [aws_security_group.main.id]
  subnets                          = var.vpc.subnet_ids
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  ip_address_type                  = var.ip_address_type
  tags                             = var.tags
}

resource "aws_lb_listener" "main" {
  for_each = var.listener_config

  load_balancer_arn = aws_lb.main.arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = contains(["TLS"], each.value.protocol) ? each.value.ssl_policy : null
  certificate_arn   = contains(["TLS"], each.value.protocol) ? each.value.certificate_arn : null

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code = "404"
    }
  }
}
