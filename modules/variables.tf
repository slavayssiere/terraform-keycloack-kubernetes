
variable "aws_key_name" {
    default = "slavayssiere_b4b"
}

variable "aws_key_path" {
    default = "/Users/sebastienlavayssiere/.ssh/slavayssiere_b4b.pem"
}

variable "aws_region" {
    default = "eu-west-1"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_a_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}

variable "private_subnet_b_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.2.0/24"
}
