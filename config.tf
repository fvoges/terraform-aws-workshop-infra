terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = ">= 0.13"
}
provider "aws" {
  region = var.aws_region
}

# terraform {
#   backend "remote" {
#     hostname = "app.terraform.io"
#     organization = "hc-implementation-services"

#     workspaces {
#       name = "boats-terraform-basic-infra"
#     }
#   }
# }
