variable "enable_cross_zone_load_balancing" {
  type = bool
  default = true
  description = "Whether or not to enable cross zone load balancing"
}

variable "enable_deletion_protection" {
  type = bool
  default = true
  description = "Flag that determine whether or not deletion protection is enabled"
}

variable "is_internal" {
  type = bool
  description = "Whether the ALB is internal or public facing"
}

variable "name" {
  type        = string
  description = "Name of ALB"
}

variable "listener_config" {
  type = map(object({
    certificate_arn  = optional(string)
    protocol         = string
    port             = number
    ssl_policy       = optional(string, "ELBSecurityPolicy-TLS13-1-2-2021-06")
    target_group_arn = string
  }))
  description = "Configuration for the listener attached to the ALB"

  validation {
    condition = alltrue([
      for listener in var.listener_config:
        contains(["TCP", "TLS", "UDP", "TCP_UDP"], listener.protocol)
    ])
    error_message = "listener_config.protocol must be one of TCP, TLS, UDP, and TCP_UDP"
  }
}

variable "ip_address_type" {
  type        = string
  description = "The type of IP address. possible values includes 'ipv4' and 'dualstack'"
  default     = "ipv4"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to resources"
}

variable "vpc" {
  type = object({
    id         = string
    cidr_block = string
    subnet_ids = list(string)
  })
  description = "VPC configuration to attach ec2 fleet"
}
