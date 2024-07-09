variable "additional_iam_policy_json" {
  type = map(string)
  default = {}
  description = "A map of IAM policies that has been encoded to json string"
}

variable "ingress_rules" {
  type = map(object({
    cidr_blocks      = list(string)
    source_port      = number
    destination_port = number
    protocol         = string
  }))

  default     = {}
  description = "Rules for allowing requests through the security group of the fleet"

  validation {
    condition = alltrue([
      for rule in var.ingress_rules: contains(["all", "tcp", "udp"], rule.protocol)
    ])
    error_message = "protocol must be one of 'all', 'tcp', 'udp'"
  }
}

variable "instance_config" {
  type = object({
    associate_public_ip_address = optional(bool, false)
    instance_type               = optional(string, "t3.micro")
  })

  default = {}
  description = <<EOT
  EC2 configuration settings
  associate_public_ip_address: Whether or not to associate public IP address with instances.
  type: The type instance. Possible values are t2.micro, t3.micro, t3a.micro
  warmup_period: Period of time, in seconds, after a newly launched Amazon EC2 instance
  can contribute to CloudWatch metrics for Auto Scaling group
EOT
}

variable "name" {
  type        = string
  description = "Name of ec2 fleet"
}

variable "placement_group" {
  type = string
  default = "partition"
  description = "Placement structure for EC2 instances"

  validation {
    condition = contains(["cluster", "partition", "spread"], var.placement_group)
    error_message = "placement_group must be one of `cluster`, `partition` and `spread`"
  }
}

variable "scaling_config" {
  type = object({
    max_size = optional(number, 1)
    min_size = optional(number, 1)
  })
  default = {}
  description = "Scaling configuration for autoscaling"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to attach to resources"
}

variable "user_data" {
  type = string
  default = null
  description = "The base64-encoded user data to provide when launching the instance."
}

variable "vpc" {
  type = object({
    id         = string
    subnet_ids = list(string)
  })
  description = "VPC configuration to attach ec2 fleet"
}
