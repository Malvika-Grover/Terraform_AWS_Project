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

//Security Group creation
resource "aws_security_group" "SG1" {
    name = "web-sg"
    vpc_id = aws_vpc.VPC_1.id

  ingress{
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    description = "Allowing HTTP trafic from anywhere"
  }
   ingress{
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    description = "Allowing SSH trafic from anywhere"
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
    description = "Allowing outbound rule from anywhere to anywhere"
  }

  tags = {
    name = "Web-SG"
  }
}

//S3 Bucket creation
resource "aws_s3_bucket" "malvikagrover" {
  bucket = "grovermalvika1234567" 
}

//Allowing public access to S3 bucker
resource "aws_s3_bucket_public_access_block" "example" {
    bucket = "grovermalvika1234567"
    
    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucketacl" {
    bucket = aws_s3_bucket.malvikagrover.id
    acl = "public-read"
}

//EC2 creation
resource "aws_instance" "Instance_1" {
    subnet_id = aws_subnet.public_subnet_1.id
    ami = var.ami_id
    instance_type = var.instance_type_value 
    security_groups = [ aws_security_group.SG1.id ]
    user_data = base64encode(file("userdata.sh"))
}

resource "aws_instance" "Instance_2" {
    subnet_id = aws_subnet.public_subnet_2.id
    ami = var.ami_id
    instance_type = var.instance_type_value 
    security_groups = [ aws_security_group.SG1.id ]
    user_data = base64encode(file("userdata2.sh"))
}

#Application Load Balancer Creation
resource "aws_alb" "myalb" {
    name = "myalb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.SG1.id]
    subnets = [ aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id ]
    enable_deletion_protection = false
}

//Target Group Creation
resource "aws_lb_target_group" "myTG" {
  name = "TG"
  port = 80
  protocol = HTTP
  vpc_id = aws_vpc.VPC_1.id

  health_check {
    path = "/"
    port = "traffic-port"

  }
}

//Attaching Target group to Instance 1
resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.myTG.arn
  target_id = aws_instance.Instance_1.id
  port = 80
}

//Attaching Targer group to Instance 2
resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb_target_group.myTG.arn
  target_id = aws_instance.Instance_2.id
  port = 80
}

//Forwarding the traffic to LoadBalancer
resource "aws_lb_listener" "listners" {
  load_balancer_arn = aws_alb.myalb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.myTG.arn
    type = "Forward"
  }
}