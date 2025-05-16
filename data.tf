# We need the supported architectures for the instance type
# to filter the AMI by architecture
data "aws_ec2_instance_type" "main" {
  instance_type = var.instance_type
}

# Search for the latest Ubuntu AMI
# with the specified architecture, virtualization type
# and the owneed by Canonical (099720109477)
# The AMI name pattern is based on the Ubuntu AMI naming convention
# and the architecture is based on the instance type
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-*-24.04-*-server-*"]
  }

  #filter by cpu architecture
  filter {
    name   = "architecture"
    values = data.aws_ec2_instance_type.main.supported_architectures
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_route53_zone" "selected" {
  name = var.route53_zone
}

data "aws_ip_ranges" "aws_ec2_connect" {
  regions  = [var.aws_region]
  services = ["ec2_instance_connect"]
}

data "aws_key_pair" "bastion" {
  key_name           = var.bastion_key_pair
  include_public_key = true
}
