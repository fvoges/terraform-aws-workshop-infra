
locals {
  users = [for i in range(var.user_count) : {
    name                = format("user%02d", i + 1)
    gecos               = "User ${i + 1}"
    primary_group       = "users"
    password            = random_pet.password[i].id
    ssh_authorized_keys = data.aws_key_pair.bastion.public_key
  }]
  user_data_params = {
    ssh_key          = data.aws_key_pair.bastion.public_key
    swap_size        = var.swap_size * 1024
    users            = local.users
    scripts_repo_url = var.scripts_repo_url
  }
  user_data = templatefile("${path.module}/templates/cloud-config.yaml.tpl", local.user_data_params)
}

resource "random_pet" "password" {
  count  = var.user_count
  length = 4
}

# output "users" {
#   value = local.users
# }

output "user_data" {
  value = local.user_data
}

resource "aws_instance" "bastion" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnets[count.index]
  # vpc_security_group_ids      = [aws_security_group.bastion.id]
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  # vpc_security_group_ids      = []
  key_name                    = var.bastion_key_pair
  associate_public_ip_address = "true"
  user_data                   = local.user_data
  # iam_instance_profile        = aws_iam_instance_profile.bastion.name
  # iam_instance_profile        = aws_iam_instance_profile.terraform_instance_profile.name
  iam_instance_profile = aws_iam_instance_profile.terraform_ec2_instance_profile.name

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.project}-bastion"
  }
}

# # create an instance profile for the bastion host to allow it to manage ec2 resources instances, security groups, key pairs, and any other resource necessary to create a new instance
# resource "aws_iam_instance_profile" "bastion" {
#   name = "${var.project}-bastion-instance-profile"
# }

# data "aws_iam_policy_document" "bastion_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#     # add a condition to the assume role policy to allow only the bastion host to assume the role
#     condition {
#       test     = "StringEquals"
#       variable = "aws:SourceArn"
#       values   = [aws_instance.bastion[0].arn]
#     }
#   }
# }

# resource "aws_iam_role" "bastion" {
#   name               = "${var.project}-bastion-role"
#   assume_role_policy = data.aws_iam_policy_document.bastion_assume_role_policy.json
# }

# resource "aws_iam_role_policy" "ec2_management_policy" {
#   name = "ec2_management_policy"
#   role = aws_iam_role.bastion.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:*",
#           # "ec2:DescribeInstances",
#           # "ec2:ModifyInstanceAttribute",
#           # "ec2:TerminateInstances",
#           # Add other necessary EC2 actions
#         ]
#         Effect   = "Allow"
#         Resource = "*" # Or specify more restrictive resource ARNs
#       }
#     ]
#   })
# }


##### try 2

# # Create IAM role for EC2
# resource "aws_iam_role" "terraform_ec2_role" {
#   name = "terraform-ec2-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # Attach policies to the role
# # You can attach AWS managed policies or create custom ones
# resource "aws_iam_role_policy_attachment" "terraform_policy_attachment" {
#   role       = aws_iam_role.terraform_ec2_role.name
#   # Use a policy with appropriate permissions for your Terraform operations
#   # For example, PowerUserAccess or a custom policy
#   policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
# }

# # Create instance profile
# resource "aws_iam_instance_profile" "terraform_instance_profile" {
#   name = "${var.project}-bastion-instance-profile"
#   role = aws_iam_role.terraform_ec2_role.name
# }