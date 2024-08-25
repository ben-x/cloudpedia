locals {
  lambda_name = "target-group-manager"
  lambda_archive_output_file = "${path.module}/files/${local.lambda_name}-lambda.zip"
  lambda_archive_source_dir = "${path.module}/files/${local.lambda_name}"
}

resource "aws_iam_role" "target_group_manager_lambda" {
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
  name_prefix = "${local.lambda_name}-role"
}

resource "aws_iam_role_policy" "target_group_manager_lambda" {
  name_prefix = "${local.lambda_name}-role-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = [
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets"
      ]
      Effect   = "Allow"
      Resource = aws_lb_target_group.central_app_tg.arn
      Sid = "AllowTargetManagement"
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
  role = aws_iam_role.target_group_manager_lambda.id
}

data "archive_file" "lambda_source_archive" {
  output_path = local.lambda_archive_output_file
  source_dir  = local.lambda_archive_source_dir
  type        = "zip"
}

resource "aws_lambda_function" "target_group_manager_lambda" {
  environment {
    variables = {
      TARGET_GROUP_ARN = aws_lb_target_group.central_app_tg.arn
    }
  }

  filename         = local.lambda_archive_output_file
  function_name    = local.lambda_name
  handler          = "index.handler"
  package_type     = "Zip"
  role             = aws_iam_role.target_group_manager_lambda.arn
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.lambda_source_archive.output_base64sha256
  timeout          = 60
  tags             = var.tags

  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_cloudwatch_log_group" "target_group_manager_lambda_log_group" {
  name = format("/aws/lambda/%s", local.lambda_name)
  retention_in_days = 3
}
