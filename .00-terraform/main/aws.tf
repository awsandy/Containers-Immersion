terraform {
  required_version = "~> 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.69.0"
    }
  }
}

provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}
