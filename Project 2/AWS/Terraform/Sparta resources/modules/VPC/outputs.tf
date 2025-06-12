output "vpc_id" {
  value = aws_vpc.sparta-vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "vpc_cidr" {
  value = aws_vpc.sparta-vpc.cidr_block
}
