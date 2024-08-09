output "aws_vpc_id" {
  value = aws_vpc.kube_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.kube_public_subnet.*.id
}

