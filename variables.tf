variable "aws_region" {
  type        = string
  description = "AWS region to deploy to"
  default     = null
}

variable "env" {
  type        = string
  description = "Environment name for this deployment used for tagging and naming resources"
  default     = "dev"
}

variable "project" {
  type        = string
  description = "Friendly name for this deployment used for tagging and naming resources"
  validation {
    condition     = length(var.project) > 0 && can(regex("^[a-z]+$", var.project))
    error_message = "Project name must be set and contain only lowercase letters"
  }
}

variable "owner" {
  type        = string
  description = "Owner of this deployment used for tagging resources"
}

variable "bastion_key_pair" {
  type        = string
  description = "Existing SSH key pair for bastion host"
}

variable "bastion_ingress_ipv4_cidr_allow" {
  type        = list(string)
  description = "List of IPv4 CIDR's to allow ingress to bastion EC2 instance security group"
}

variable "bastion_ingress_ipv6_cidr_allow" {
  type        = list(string)
  description = "List of IPv6 CIDR's to allow ingress to bastion EC2 instance security group"
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

variable "user_count" {
  type        = number
  description = "Number of users to create"
  default     = 15
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for lab host"
  default     = "t4g.micro"
}

variable "swap_size" {
  type        = number
  description = "Swap size in GiB"
  default     = 1
}
variable "aws_profile" {
  type        = string
  description = "AWS profile to use"
  default     = null
}

variable "scripts_repo_url" {
  type        = string
  description = "URL of the scripts repo"
  default     = null
}