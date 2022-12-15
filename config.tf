terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.46.0, <5.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0, <3.0.0"
    }
  }
  required_version = ">= 0.13"
}
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.tags
  }
}
