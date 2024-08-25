locals {
  nat_az   = "a" # we're using a single AZ to save cost. You should use multi-az for your production workload.
  vpc_name = "vpc-${var.aws_region}"
}

variable "app_port" {
  type = number
  default = 80
  description = "The port on which the backend application runs on"
}

variable "dns_config" {
  type = object({
    additional_cnames = list(string)
    cert_arn          = string
    domain_name       = string
    route53_zone_id   = string
  })

  description = "Configuration of domain name and certificate"
}

variable "aws_region" {
  type        = string
  description = "Default AWS Region"
}

variable "cidr_blocks" {
  type = object({
    vpc             = string
    private_subnet  = map(string)
    public_subnet   = map(string)
  })

  description = <<EOT
  CIDR block values for VPCs and Subnets
  Example:
  {
    vpc = "10.0.0.1/16",
    private_subnet = {
      a = "10.0.1.0/24",
      b = "10.0.2.0/24",
      c = "10.0.3.0/24"
    },
    public_subnet = {
      a = "10.0.1.0/24",
      b = "10.0.2.0/24",
      c = "10.0.3.0/24"
    }
  }
  EOT
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to resources"
}
