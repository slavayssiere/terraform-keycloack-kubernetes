
data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7*"]
  }

  filter {
    name   = "owner-id"
    values = ["679593333241"]
  }
}

data "aws_ami" "coreos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CoreOS-*"]
  }

  filter {
    name   = "owner-id"
    values = ["679593333241"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-zesty*"]
  }
}