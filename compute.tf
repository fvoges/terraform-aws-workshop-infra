
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
  length = 2
}

# output "user_data" {
#   value = local.user_data
# }

resource "aws_instance" "bastion" {
  count                       = 1
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[count.index]
  vpc_security_group_ids      = [module.bastion_sg.security_group_id]
  key_name                    = var.bastion_key_pair
  associate_public_ip_address = "true"
  user_data                   = local.user_data
  iam_instance_profile        = aws_iam_instance_profile.terraform_ec2_instance_profile.name

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.project}-bastion"
  }
}
