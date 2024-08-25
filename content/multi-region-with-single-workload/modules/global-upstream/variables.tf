variable "ca_west_1" {
  type = object({
    dns_config = object({
      domain_name = string
      additional_cnames = optional(list(string), [])
      route53_zone_id = string
    })
  })

  description = "Values to setup resource in ca-west-1 region"
}

variable "eu_central_1" {
  type = object({
    dns_config = object({
      domain_name = string
      additional_cnames = optional(list(string), [])
      route53_zone_id = string
    })
  })

  description = "Values to setup resource in eu-central-1 region"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to resources"
}
