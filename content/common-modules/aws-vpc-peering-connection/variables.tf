variable "accepter" {
  type = object({
    vpc_id = string
    region = string
  })

  description = "Details of the VPC accepting the peering connection"
}

variable "allow_dns_resolution" {
  type    = bool
  default = false
  description = "Indicates whether or not to allow both VPC resolve dns of the other"
}

variable "name" {
  type        = string
  description = "Name of VPC peering connection"
}

variable "requester" {
  type = object({
    vpc_id = string
    region = string
  })

  description = "Details of the VPC requesting the peering connection"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to resources"
}
