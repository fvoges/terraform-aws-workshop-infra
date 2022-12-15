variable "aws_region" {
  type        = string
  description = "AWS region to deploy to"
  default     = "eu-west-2"
}

variable "project" {
  type        = string
  description = "Friendly name for this deployment used for tagging and naming resources"
}

variable "bastion_key_pair" {
  type        = string
  description = "Existing SSH key pair for bastion host"
}

variable "bastion_ingress_cidr_allow" {
  type        = list(string)
  description = "List of CIDR's to allow ingress to bastion EC2 instance security group"
}

variable "route53_zone" {
  type        = string
  description = "Route53 hosted DNS domain used to setup DNS records"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default     = {}
}
