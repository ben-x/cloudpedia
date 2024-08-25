variable "ca_west_1" {
  type = object({
    aws_region = string
    subnets = map(object({
      acl_id  = string
      subnets = map(object({
        id             = string
        cidr_block     = string
      }))
      route_tables = map(object({
        id = string
      }))
    }))
    vpc = map(object({
      id         = string
      cidr_block = string
    }))
  })
}

variable "eu_central_1" {
  type = object({
    aws_region = string
    subnets = map(object({
      acl_id  = string
      subnets = map(object({
        id             = string
        cidr_block     = string
      }))
      route_tables = map(object({
        id = string
      }))
    }))
    vpc = map(object({
      id         = string
      cidr_block = string
    }))
  })
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to resources"
}
