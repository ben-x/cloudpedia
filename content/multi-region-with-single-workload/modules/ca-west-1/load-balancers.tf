resource "aws_lb_target_group" "app_fleet_tg" {
  name        = "app-fleet-tg"
  port        = var.app_port
  protocol    = "HTTP"
  target_type = "instance"
  tags        = var.tags
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 15
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 2
  }
}

resource "aws_autoscaling_attachment" "app_fleet_tg_attachment" {
  autoscaling_group_name = module.app_fleet.autoscaling_group.name
  lb_target_group_arn    = aws_lb_target_group.app_fleet_tg.arn
}

module "app_alb" {
  source = "../../../common-modules/aws-alb"

  allow_all_egress           = true
  enable_deletion_protection = false
  idle_timeout_seconds       = "60"

  name          = "app-alb"
  is_internal   = false
  tags          = var.tags

  listener_config = {
    http_port_80 = {
      protocol = "HTTP"
      port     = "80"
    }
    http_port_443 = {
      protocol = "HTTPS"
      port     = "443"
      certificate_arn = var.dns_config.cert_arn
    }
  }

  vpc = {
    id         = aws_vpc.main.id
    cidr_block = aws_vpc.main.cidr_block
    subnet_ids = local.public_subnet_ids
  }
}

resource "aws_lb_listener_rule" "alb_http_port_80" {
  listener_arn = module.app_alb.listeners["http_port_80"].arn
  priority     = 1
  tags         = var.tags

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = concat([var.dns_config.domain_name], var.dns_config.additional_cnames)
    }
  }
}

resource "aws_lb_listener_rule" "alb_http_port_443" {
  listener_arn = module.app_alb.listeners["http_port_443"].arn
  priority     = 1
  tags         = var.tags

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_fleet_tg.arn
  }

  condition {
    host_header {
      values = concat([var.dns_config.domain_name], var.dns_config.additional_cnames)
    }
  }
}

# module "app_nlb" {
#   source = "../../../common-modules/aws-nlb"
#
#   enable_deletion_protection = false
#   is_internal                = true
#   name                       = "app-nlb"
#   tags                       = var.tags
#
#   listener_config = {
#     http_port_80 = {
#       protocol         = "TCP"
#       port             = "80"
#       target_group_arn = aws_lb_target_group.app_fleet_tg.arn
#     }
#   }
#
#   vpc = {
#     id         = aws_vpc.main.id
#     cidr_block = aws_vpc.main.cidr_block
#     subnet_ids = local.private_subnet_ids
#   }
# }
