resource "aws_iam_role" "lambda_with_aws_sdk_layer_role" {
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
  name_prefix = "lambda-with-aws-sdk-layer-role"
}

resource "aws_iam_role_policy" "lambda_with_aws_sdk_layer_role_policy" {
  name_prefix = "lambda-with-aws-sdk-layer-role-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
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
  role = aws_iam_role.lambda_with_aws_sdk_layer_role.id
}
