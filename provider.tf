terraform {
  required_version = ">= 1.3, < 2.0.0"

  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }
  }
}