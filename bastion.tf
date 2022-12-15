resource "aws_instance" "bastion" {
  count                       = 1
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[count.index]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.bastion_key_pair
  associate_public_ip_address = "true"
  user_data                   = data.template_file.bastion_user_data.rendered

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.project}-bastion"
  }
}

resource "aws_route53_record" "bastion" {
  count   = 1
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.project}-bastion.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.bastion[count.index].public_ip]
}

resource "aws_security_group" "bastion" {
  name   = "${var.project}-sg-bastion-allow"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "bastion_ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.bastion_ingress_cidr_allow
  description = "Allow SSH to bastion host"

  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow egress from bastion host"

  security_group_id = aws_security_group.bastion.id
}
