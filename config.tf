terraform {
  required_version = ">= 0.12.12"
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
