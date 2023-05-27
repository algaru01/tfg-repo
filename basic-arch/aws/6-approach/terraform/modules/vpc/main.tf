resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = "myMainVPC"
  }
}

resource "aws_subnet" "public" {
  count = var.public_subnets != null ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.public_subnets_availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = var.private_subnets != null ? length(var.private_subnets) : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.private_subnets_availability_zone[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet${count.index}"
  }
}

resource "aws_subnet" "nat" {
  count = var.private_subnets != null ? 1 : 0
  
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.nat_subnet
  availability_zone = var.private_subnets_availability_zone[0]
  map_public_ip_on_launch = true
}

resource "aws_eip" "nat" {
  count = var.private_subnets != null ? length(var.private_subnets) : 0
  vpc = "true"

  #Como recomiendan en la documentacion, puede que sea necesario incluir esta dependencia.
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count = var.private_subnets != null ? 1 : 0
  subnet_id = aws_subnet.nat[0].id
  allocation_id = aws_eip.nat[0].id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "myInternetGateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }
}

resource "aws_route_table_association" "private" {
  count = var.private_subnets != null ? length(var.private_subnets) : 0

  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count = var.public_subnets != null ? length(var.public_subnets) : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "nat" {
  count = var.private_subnets != null ? 1 : 0

  subnet_id      = aws_subnet.nat[0].id
  route_table_id = aws_route_table.public.id
}