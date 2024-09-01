resource "aws_placement_group" "main" {
  name     = var.name
  strategy = var.placement_group
  tags     = var.tags
}

resource "aws_autoscaling_group" "main" {
  name                      = var.name
  default_cooldown          = 300
  desired_capacity          = var.scaling_config.min_size
  force_delete              = false
  health_check_grace_period = 300
  health_check_type         = "EC2"
  max_size                  = var.scaling_config.max_size
  min_size                  = var.scaling_config.min_size
  placement_group           = aws_placement_group.main.name
  vpc_zone_identifier       = var.vpc.subnet_ids

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  dynamic "tag" {
    for_each = merge(var.tags, {
      Name = var.name
    })

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }
}
