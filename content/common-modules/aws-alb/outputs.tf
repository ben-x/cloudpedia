output "arn" {
  value = aws_lb.main.arn
}

output "dns_name" {
  value = aws_lb.main.dns_name
}

output "id" {
  value = aws_lb.main.id
}

output "name" {
  value = aws_lb.main.name
}

output "security_group_id" {
  value = aws_security_group.main.id
}

output "listeners" {
  value = {
    for name, listener in var.listener_config: name => {
      arn      = aws_lb_listener.main[name].arn
      port     = listener.port
      protocol = listener.protocol
    }
  }
}

output "zone_id" {
  value = aws_lb.main.zone_id
}
