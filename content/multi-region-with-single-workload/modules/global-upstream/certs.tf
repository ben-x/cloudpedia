resource "aws_acm_certificate" "ca_west_1_cert" {
  provider = aws.ca-west-1

  domain_name = var.ca_west_1.dns_config.domain_name
  subject_alternative_names = var.ca_west_1.dns_config.additional_cnames

  tags = merge(var.tags, {
    Name = "ca-west-1-cert"
    Description = "Certificate for ca-west-1 applications"
  })

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "ca_west_1_cert" {
  provider = aws.ca-west-1

  certificate_arn         = aws_acm_certificate.ca_west_1_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.ca_west_1_domain_validation : record.fqdn]
}

resource "aws_acm_certificate" "eu_central_1_cert" {
  provider = aws.eu-central-1

  domain_name = var.eu_central_1.dns_config.domain_name
  subject_alternative_names = var.eu_central_1.dns_config.additional_cnames

  tags = merge(var.tags, {
    Name = "eu-central-1-cert"
    Description = "Certificate for eu-central-1 applications"
  })

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "eu_central_1_cert" {
  provider = aws.eu-central-1

  certificate_arn         = aws_acm_certificate.eu_central_1_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.eu_central_1_domain_validation : record.fqdn]
}
