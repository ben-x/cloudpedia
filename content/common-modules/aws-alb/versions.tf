terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.38"
    }
  }

  required_version = ">= 1.7"
}
