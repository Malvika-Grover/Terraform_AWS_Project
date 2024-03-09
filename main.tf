//VPC Creation
resource "aws_vpc" "VPC_1" {
  cidr_block = var.cidr_vpc
}

//Subnet Creation
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.VPC_1.id
  cidr_block = var.cidr_public_subnet_1
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.VPC_1.id
  cidr_block = var.cidr_public_subnet_2
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

//Internet Gateway
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.VPC_1.id
  
}

//Route Table
resource "aws_route_table" "RT1" {
  vpc_id = aws_vpc.VPC_1.id

//Defining routes
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

//Subnet Association with Route table so that it has internet access
resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.RT1.id 
}

resource "aws_route_table_association" "rta2" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.RT1.id 
}
