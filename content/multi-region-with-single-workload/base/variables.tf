locals {
  default_tags = {
    ManagedBy = "Terraform"
  }
}

variable "default_aws_region" {
  type        = string
  default     = "ca-west-1"
  description = "Default AWS Region"
}

variable "route53_zone_name" {
  type = string
  description = "The name of the route53 zone to launch the application"
}

variable "route53_zone_id" {
  type = string
  description = "The id of the route53 zone to launch the application"
}
