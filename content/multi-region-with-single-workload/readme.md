# Multi-Region Deployment With Single Workload

This project describes how to serve multiple regions using a single workload.

## Requirements

- An AWS account
- AWS CLI installed and configured with credentials that have sufficient permissions
- Terraform v1.7 or later

## Setup

1. Install terraform
2. Configure terraform with AWS credentials
3. Cd ./base
4. Update values in variables.tf
5. run `terraform apply` to deploy the resources
6. By default, the autoscaling is set to 0 instance. Increase to 1 or more
7. Enter endpoint on browser to load deployed application
