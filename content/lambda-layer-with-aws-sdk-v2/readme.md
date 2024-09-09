# Lambda Layer With AWS SDK V2

This project describe how to create a Lambda function layer containing aws-sdk package.

## Requirements

- An AWS account
- AWS CLI installed and configured with credentials that have sufficient permissions
- Terraform v1.7 or later

## Setup

1. Install terraform
2. Configure terraform with AWS credentials
3. Go into the files directory: `cd files`
4. Generate the aws-sdk package by executing `generate-layer.sh`
5. Run `terraform init` && `terraform apply`
6. Test the created lambda function.

## Disclaimer

The project is made available as is. Review before using for production workload.
