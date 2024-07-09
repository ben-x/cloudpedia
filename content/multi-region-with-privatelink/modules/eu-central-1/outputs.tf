output "vpc" {
  value = aws_vpc.main
}

output "private_subnets" {
  value = module.private_subnet
}

output "public_subnets" {
  value = module.public_subnet
}

