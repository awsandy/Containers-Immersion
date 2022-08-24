terraform {
  required_version = "~> 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.27.0"
    }
  }
}

provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = "default"
}
