resource "aws_lb" "main" {
  name                             = var.name
  internal                         = var.is_internal
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.main.id]
  subnets                          = var.vpc.subnet_ids
  idle_timeout                     = var.idle_timeout_seconds
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = var.enable_deletion_protection
  ip_address_type                  = var.ip_address_type
  tags                             = var.tags
}

resource "aws_lb_listener" "main" {
  for_each = var.listener_config

  load_balancer_arn = aws_lb.main.arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = contains(["HTTPS"], each.value.protocol) ? each.value.ssl_policy : null
  certificate_arn   = contains(["HTTPS"], each.value.protocol) ? each.value.certificate_arn : null

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code = "404"
    }
  }
}
