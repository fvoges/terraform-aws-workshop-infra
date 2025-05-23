output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "bastion" {
  value = aws_route53_record.bastion[0].name
}

output "user_credentials" {
  value = [for user in local.users : {
    host = aws_route53_record.bastion[0].name,
    user = user.name,
    pass = user.password
  }]
}
