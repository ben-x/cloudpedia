resource "aws_route53_record" "customer_alb" {
  zone_id = var.dns_config.route53_zone_id
  name    = var.dns_config.domain_name
  type    = "A"

  alias {
    name                   = module.app_alb.dns_name
    zone_id                = module.app_alb.zone_id
    evaluate_target_health = true
  }
}
