output "autoscaling_group" {
  value = {
    arn = aws_autoscaling_group.main.arn
    id   = aws_autoscaling_group.main.id
    name = aws_autoscaling_group.main.name
  }
}

output "launch_template" {
  value = {
    id = aws_launch_template.main.id
  }
}

output "security_group" {
  value = {
    id = aws_security_group.main.id
  }
}
