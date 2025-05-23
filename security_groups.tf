module "bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = ">= 5.3.0, <6.0.0"

  name        = "bastion-host"
  description = "Security group for bastion host with SSH access limited from public internet"
  vpc_id      = module.vpc.vpc_id

  egress_rules             = ["all-all"]
  ingress_cidr_blocks      = distinct(concat(var.bastion_ingress_ipv4_cidr_allow, data.aws_ip_ranges.aws_ec2_connect.cidr_blocks))
  ingress_ipv6_cidr_blocks = distinct(concat(var.bastion_ingress_ipv6_cidr_allow, data.aws_ip_ranges.aws_ec2_connect.ipv6_cidr_blocks))
  ingress_rules            = ["ssh-tcp", "http-80-tcp", "https-443-tcp"]
}
