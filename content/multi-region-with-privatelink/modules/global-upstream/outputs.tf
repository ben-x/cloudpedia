output "certificates" {
  value = {
    ca_west_1    = aws_acm_certificate.ca_west_1_cert
    eu_central_1 = aws_acm_certificate.eu_central_1_cert
  }
}

output "domain_config" {
  value = {
    ca_west_1    = merge(var.ca_west_1.dns_config, {
      cert_arn = aws_acm_certificate.ca_west_1_cert.arn
    })
    eu_central_1 = merge(var.eu_central_1.dns_config, {
      cert_arn = aws_acm_certificate.eu_central_1_cert.arn
    })
  }
}
