resource "aws_vpc" "my_vpc" {
  cidr_block     var.vpc_cidr
  tags = {
    Name = "my-vpc"
  }
} 

resource "aws_subnet" "public_subnet"{
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
} 
resource "aws_subnet" "private_subnet"{
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidr
  tags = {
    Name = "private-subnet"
  }
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_"
