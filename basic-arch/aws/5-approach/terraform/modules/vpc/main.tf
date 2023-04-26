resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = "myMainVPC"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet${count.index}"
  }
}

resource "aws_subnet" "jumpbox" {
  count = var.jumpbox_subnet != null ? 1 : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.jumpbox_subnet
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "jumpbox-subnet${count.index}"
  }
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

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "jumpbox" {
  count = var.jumpbox_subnet != null ? 1 : 0

  subnet_id      = aws_subnet.jumpbox[0].id
  route_table_id = aws_route_table.public.id
}