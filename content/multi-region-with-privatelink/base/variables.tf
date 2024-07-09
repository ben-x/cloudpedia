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
