data "archive_file" "lambda_source_archive" {
  output_path = "${path.module}/files/application-lambda.zip"
  source_dir  = "${path.module}/files/application"
  type        = "zip"
}

resource "aws_lambda_layer_version" "aws_sdk_v2" {
  compatible_runtimes  = ["nodejs18.x", "nodejs20.x"]
  description          = "Layer container aws-sdk v2"
  filename             = "${path.module}/files/aws-sdk-v2.zip"
  layer_name           = "aws-sdk-v2"
  source_code_hash     = filebase64sha256("${path.module}/files/aws-sdk-v2.zip")
}

resource "aws_lambda_function" "lambda_with_aws_sdk_layer" {
  environment {
    variables = {
      AWS_SDK_JS_SUPPRESS_MAINTENANCE_MODE_MESSAGE = 1
      S3_BUCKET_NAME = "some-random-bucket"
    }
  }

  filename         = "${path.module}/files/application-lambda.zip"
  function_name    = "lambda-with-aws-sdk-layer"
  handler          = "index.handler"
  layers           = [aws_lambda_layer_version.aws_sdk_v2.arn]
  package_type     = "Zip"
  role             = aws_iam_role.lambda_with_aws_sdk_layer_role.arn
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.lambda_source_archive.output_base64sha256
  timeout          = 60 # 1 minute
  tags             = local.default_tags
}
