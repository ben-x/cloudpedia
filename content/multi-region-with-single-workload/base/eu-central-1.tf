locals {
  eu_central_1 = {
    cidr_blocks = {
      vpc = "192.168.0.0/20" # 4096 IPs
      private_subnet = {
        a = "192.168.0.0/23" # 512 IPs
        b = "192.168.2.0/23" # 512 IPs
      }
      public_subnet  = {
        a = "192.168.4.0/23" # 512 IPs
        b = "192.168.6.0/23" # 512 IPs
      }
    }

    dns_config = {
      domain_name = "eu.cloudpedia.xyz"
      additional_cnames = ["www.eu.cloudpedia.xyz"]
      route53_zone_id = "Z03282312GEO9VCQYU86I"
    }
  }
}
