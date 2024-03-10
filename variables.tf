
variable "cidr_vpc" {
  description = "CIDR block for VPC"
  default = "10.0.0.0/16"
}

variable "cidr_public_subnet_1" {
  description = "CIDR block for Public Subnet"
  default = "10.0.0.0/24"
  
}

variable "cidr_public_subnet_2" {
  description = "CIDR block for Private Subnet"
  default = "10.0.1.0/24"
  
}

variable "ami_id" {
    default = "ami-07d9b9ddc6cd8dd30"
    description = "AMI ubuntu"  
}

variable "instance_type_value" {
  default = "t2.micro"
  description = "Free tier instance type"
}
