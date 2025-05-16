
resource "aws_route53_record" "bastion" {
  count   = 1
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.project}-bastion.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "60"
  records = [aws_instance.bastion[count.index].public_ip]
}
