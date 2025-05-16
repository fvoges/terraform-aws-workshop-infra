
# resource "aws_security_group" "bastion" {
#   name   = "${var.project}-sg-bastion-allow"
#   vpc_id = module.vpc.vpc_id
# }

# resource "aws_security_group_rule" "bastion_ingress" {
#   type        = "ingress"
#   from_port   = 22
#   to_port     = 22
#   protocol    = "tcp"
#   cidr_blocks = var.bastion_ingress_cidr_allow
#   description = "Allow SSH to bastion host"

#   security_group_id = aws_security_group.bastion.id
# }

# resource "aws_security_group_rule" "bastion_egress" {
#   type        = "egress"
#   from_port   = 0
#   to_port     = 0
#   protocol    = "-1"
#   cidr_blocks = ["0.0.0.0/0"]
#   description = "Allow egress from bastion host"

#   security_group_id = aws_security_group.bastion.id
# }



# module "ssh_sg" {
#   source = "terraform-aws-modules/security-group/aws//modules/ssh"

#   name        = "ssh-server"
#   description = "Security group for ssh-server with SSH ports open within VPC"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = ["10.10.0.0/16"]
# }

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
  # ingress_with_cidr_blocks = [
  #   {
  #     from_port   = 8080
  #     to_port     = 8090
  #     protocol    = "tcp"
  #     description = "User-service ports"
  #     cidr_blocks = "10.10.0.0/16"
  #   },
  #   {
  #     rule        = "postgresql-tcp"
  #     cidr_blocks = "0.0.0.0/0"
  #   },
  # ]
}