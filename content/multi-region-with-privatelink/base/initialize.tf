provider "aws" {
  alias   = "ca-west-1"
  region  = "ca-west-1"
  profile = "cloudpedia-terraform-admin"
}

provider "aws" {
  alias   = "eu-central-1"
  region  = "eu-central-1"
  profile = "cloudpedia-terraform-admin"
}
