resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "my_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id  = aws_vpc.my_vpc.id
    cidr_block = var.public_subnet_cidr
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true
    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.private_subnet_cidr
    availability_zone = var.availability_zone
    tags = {
        Name = "private_subnet"
    }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "IGW"
    }
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags = {
        Name = "nat_eip"
    }
}

resource "aws_nat_gateawat" "nat" {
    subnet_id =aws_subnet.public_subnet.id 
    allcation_id = aws_eip.nat_eip.id
    tags = {
        Name = "nat"
    }
}

resource "aws_route_table" "pubic_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        gateway_id = aws_internet_gateway.IGW.id
        cidr_block ="0.0.0.0/0"
    }
    tags = {
        Name = "public_rt"

    }
}

resource "aws_route_table_assocition" "public_rt_assoc" {
    subnet_id =aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id

}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        nat_gateway_id = aws_nat_gateway.nat.id
        cidr_block = "0.0.0.0/0"
    }
    tags = {
        Name = "private_rt"
    }
}

resource "aws_route_table_association" "private_rt_assoc" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "sg" {
    name = var.sg_name
    description = var.sg_name
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "my_sg"
    }
    