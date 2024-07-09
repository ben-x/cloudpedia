variable "allow_all_egress" {
  type = bool
  default = false
  description = "A flag that determine whether or not to allow all egress from the alb"
}

variable "enable_deletion_protection" {
  type = bool
  default = true
  description = "Flag that determine whether or not deletion protection is enabled"
}

variable "idle_timeout_seconds" {
  type = number
  description = "The time in seconds that the connection is allowed to be idle"
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
    protocol        = string
    port            = number
    ssl_policy      = optional(string, "ELBSecurityPolicy-TLS13-1-2-2021-06")
    certificate_arn = optional(string)
  }))
  description = "Configuration for the listener attached to the ALB"

  validation {
    condition = alltrue([
      for listener in var.listener_config:
      contains(["HTTP", "HTTPS"], listener.protocol)
    ])
    error_message = "listener_config.protocol must be one of HTTP and HTTPS"
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
