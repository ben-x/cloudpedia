locals {
  lambda_archive_output_file = "${path.module}/files/autoscaling-lifecycle-hook-lambda.zip"
  lambda_archive_source_dir = "${path.module}/files/autoscaling-lifecycle-hook"
  lambda_name = "autoscaling-lifecycle-hook-target"
}

data "archive_file" "lambda_source_archive" {
  output_path = local.lambda_archive_output_file
  source_dir  = local.lambda_archive_source_dir
  type        = "zip"
}

resource "aws_iam_role" "autoscaling_lifecycle_hook_lambda_target" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
  name_prefix = "autoscaling-lifecycle-hook-target-role"
}

resource "aws_iam_role_policy" "autoscaling_lifecycle_hook_lambda_target" {
  name_prefix = "autoscaling-lifecycle-hook-target-role-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["autoscaling:CompleteLifecycleAction"]
      Effect   = "Allow"
      Resource = module.app_fleet.autoscaling_group.arn
      Sid = "AllowLifecycleCompletion"
    }, {
      Action   = ["events:PutEvents"]
      Effect   = "Allow"
      Resource = "*"
      Sid = "AllowPutEvent"
    }, {
      Action = ["ec2:DescribeInstances"]
      Effect = "Allow"
      Resource = "*"
      Sid = "AllowDescribeEC2Instances"
    }, {
      Action   = [
        "logs:CreateLogStream",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents"
      ]
      Effect   = "Allow"
      Resource = "*"
      Sid = "AllowLogManagement"
    }]
  })
  role = aws_iam_role.autoscaling_lifecycle_hook_lambda_target.id
}

resource "aws_lambda_function" "autoscaling_lifecycle_hook_lambda_target" {
  environment {
    variables = {
      TARGET_EVENT_BUS_ARN =  "arn:aws:events:eu-central-1:${data.aws_caller_identity.current.account_id}:event-bus/${local.event_bus_name}" # local.event_bus_arn
      TARGET_EVENT_BUS_REGION = "eu-central-1"
      APP_PORT = var.app_port
      AVAILABILITY_ZONE = "all"
      DEREGISTRATION_DELAY_SECONDS = 60 * 5 # 5mins
    }
  }

  filename         = local.lambda_archive_output_file
  function_name    = local.lambda_name
  handler          = "index.handler"
  package_type     = "Zip"
  role             = aws_iam_role.autoscaling_lifecycle_hook_lambda_target.arn
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.lambda_source_archive.output_base64sha256
  timeout          = 60 * 6  # 6mins
  tags             = var.tags

  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_cloudwatch_log_group" "autoscaling_lifecycle_hook_lambda_log_group" {
  name = format("/aws/lambda/%s", local.lambda_name)
  retention_in_days = 3
}
