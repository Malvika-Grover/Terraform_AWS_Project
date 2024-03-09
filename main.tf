//VPC Creation
resource "aws_vpc" "VPC_1" {
  cidr_block = var.cidr_vpc
}

//Subnet Creation
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.VPC_1.id
  cidr_block = var.cidr_public_subnet
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.VPC_1.id
  cidr_block = var.cidr_private_subnet
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

//Internet Gateway
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.VPC_1.id
  
}

