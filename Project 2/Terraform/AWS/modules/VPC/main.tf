resource "aws_vpc" "sparta-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "sparta-vpc-gateway" {
  vpc_id = aws_vpc.sparta-vpc.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.sparta-vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az_public

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.sparta-vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az_private

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.sparta-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sparta-vpc-gateway.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
