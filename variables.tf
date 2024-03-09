
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