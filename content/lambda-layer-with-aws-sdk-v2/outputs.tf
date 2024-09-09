output "aws_sdk_layer_arn" {
  value = aws_lambda_layer_version.aws_sdk_v2.arn
}

output "lambda_with_layer" {
  value = {
    arn = aws_lambda_function.lambda_with_aws_sdk_layer.arn
  }
}
