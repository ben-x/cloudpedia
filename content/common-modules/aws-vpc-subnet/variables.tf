variable "aws_region" {
  type        = string
  description = "Default AWS Region"
}

variable "cidr_blocks" {
  type        = map(string)
  description = <<EOT
  CIDR block of subnet
  Example:
  {
    a = "10.0.1.0/24",
    b = "10.0.2.0/24",
    c = "10.0.3.0/24"
  }
  EOT
}

variable "name" {
  type        = string
  description = "Name of subnet"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to resources"
}

variable "vpc" {
  type = object({
    id = string
  })
  description = "ID of VPC to attach subnet"
}
