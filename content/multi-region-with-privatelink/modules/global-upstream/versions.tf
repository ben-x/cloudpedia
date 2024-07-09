terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.38"
      configuration_aliases = [
        aws.ca-west-1,
        aws.eu-central-1
      ]
    }
  }

  required_version = ">= 1.7"
}
