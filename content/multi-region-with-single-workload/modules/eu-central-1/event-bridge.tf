locals {
  event_bus_name = "default"
}

resource "aws_cloudwatch_event_rule" "capture_app_fleet_instance_launch" {
  name           = "capture-app-fleet-instance-launch"
  description    = "Captures event when a new instance is launched in the control region"
  event_bus_name = local.event_bus_name

  event_pattern  = jsonencode({
    detail-type = ["INSTANCE_IS_LAUNCHING"]
    source = ["cloudpedia"]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "capture_app_fleet_instance_launch_rule_target" {
  arn            = aws_lambda_function.target_group_manager_lambda.arn
  event_bus_name = local.event_bus_name
  rule           = aws_cloudwatch_event_rule.capture_app_fleet_instance_launch.name
  target_id      = "app-fleet-instance-launch-rule-target"
}

resource "aws_lambda_permission" "trigger_app_fleet_instance_launch_rule_target" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.target_group_manager_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.capture_app_fleet_instance_launch.arn
}

resource "aws_cloudwatch_event_rule" "capture_app_fleet_instance_termination" {
  name           = "capture-app-fleet-instance-termination"
  description    = "Captures event when a new instance is about to be terminated in the control region"
  event_bus_name = local.event_bus_name

  event_pattern  = jsonencode({
    detail-type = ["INSTANCE_IS_TERMINATING"]
    source = ["cloudpedia"]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "capture_app_fleet_instance_termination_rule_target" {
  arn            = aws_lambda_function.target_group_manager_lambda.arn
  event_bus_name = local.event_bus_name
  rule           = aws_cloudwatch_event_rule.capture_app_fleet_instance_termination.name
  target_id      = "app-fleet-instance-termination-rule-target"
}

resource "aws_lambda_permission" "trigger_app_fleet_instance_termination_rule_target" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.target_group_manager_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.capture_app_fleet_instance_termination.arn
}
