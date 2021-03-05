data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "bastion_user_data" {
  template = file("${path.module}/templates/bastion_user_data.sh")
}

data "aws_route53_zone" "selected" {
  name = var.route53_zone
}
