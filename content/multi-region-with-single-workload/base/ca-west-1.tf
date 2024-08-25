locals {
  ca_west_1 = {
    cidr_blocks = {
      vpc = "172.17.0.0/20" # 4096 IPs
      private_subnet = {
        a = "172.17.0.0/23" # 512 IPs
        b = "172.17.2.0/23" # 512 IPs
      }
      public_subnet  = {
        a = "172.17.4.0/23" # 512 IPs
        b = "172.17.6.0/23" # 512 IPs
      }
    }

    dns_config = {
      domain_name = "ca.cloudpedia.xyz"
      additional_cnames = ["www.ca.cloudpedia.xyz"]
      route53_zone_id = "Z03282312GEO9VCQYU86I"
    }
  }
}
