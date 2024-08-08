output "aws_vpc_id" {
  value = aws_vpc.terraform_prod.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.*.id
}

