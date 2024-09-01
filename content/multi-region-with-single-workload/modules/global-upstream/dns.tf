resource "aws_route53_record" "ca_west_1_domain_validation" {
  provider = aws.ca-west-1

  for_each = {
    for dvo in aws_acm_certificate.ca_west_1_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.ca_west_1.dns_config.route53_zone_id
}

resource "aws_route53_record" "eu_central_1_domain_validation" {
  provider = aws.eu-central-1

  for_each = {
    for dvo in aws_acm_certificate.eu_central_1_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.eu_central_1.dns_config.route53_zone_id
}
