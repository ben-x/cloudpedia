locals {
  event_bus_name = "default"
  event_bus_arn = "arn:aws:events:${var.aws_region}:${data.aws_caller_identity.current.account_id}:event-bus/${local.event_bus_name}"
}

resource "aws_cloudwatch_event_rule" "capture_launch_autoscaling_lifecycle_hook" {
  name           = "capture-app-fleet-launch-autoscaling-hook"
  description    = "Capture event when autoscaling launches new instance"
  event_bus_name = local.event_bus_name

  event_pattern  = jsonencode({
    detail-type = ["EC2 Instance-launch Lifecycle Action"]
    detail = {
      AutoScalingGroupName = [module.app_fleet.autoscaling_group.name]
      LifecycleHookName    = [aws_autoscaling_lifecycle_hook.instance_launch_lifecycle_hook.name]
    }
    source = ["aws.autoscaling"]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "launch_autoscaling_lifecycle_hook_lambda_target" {
  arn            = aws_lambda_function.autoscaling_lifecycle_hook_lambda_target.arn
  event_bus_name = local.event_bus_name
  rule           = aws_cloudwatch_event_rule.capture_launch_autoscaling_lifecycle_hook.name
  target_id      = "launch-autoscaling-lifecycle-hook-lambda-target"
}

resource "aws_lambda_permission" "launch_asc_lifecycle_invoke_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.autoscaling_lifecycle_hook_lambda_target.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.capture_launch_autoscaling_lifecycle_hook.arn
}

resource "aws_cloudwatch_event_rule" "capture_termination_autoscaling_lifecycle_hook" {
  name           = "capture-app-fleet-termination-autoscaling-hook"
  description    = "Capture event when autoscaling terminates an instance"
  event_bus_name = local.event_bus_name

  event_pattern  = jsonencode({
    detail-type = ["EC2 Instance-terminate Lifecycle Action"]
    detail = {
      AutoScalingGroupName = [module.app_fleet.autoscaling_group.name]
      LifecycleHookName    = [aws_autoscaling_lifecycle_hook.instance_termination_lifecycle_hook.name]
    }
    source = ["aws.autoscaling"]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "app_fleet_termination_autoscaling_lifecycle_hook_lambda_target" {
  arn            = aws_lambda_function.autoscaling_lifecycle_hook_lambda_target.arn
  event_bus_name = local.event_bus_name
  rule           = aws_cloudwatch_event_rule.capture_termination_autoscaling_lifecycle_hook.name
  target_id      = "termination-autoscaling-lifecycle-hook-lambda-target"
}

resource "aws_lambda_permission" "termination_asc_lifecycle_invoke_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.autoscaling_lifecycle_hook_lambda_target.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.capture_termination_autoscaling_lifecycle_hook.arn
}
