
resource "aws_eip" "seb_test_eip_nat" {
    instance = "${aws_instance.nat_seb_test.id}"
    vpc = true
}

/*
  NAT Instance
*/
resource "aws_security_group" "nat_sg" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_a_cidr}","${var.private_subnet_b_cidr}"]
    }
    ingress {
        from_port = 8001
        to_port = 8001
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_a_cidr}","${var.private_subnet_b_cidr}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 6443
        to_port = 6443
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    vpc_id = "${aws_vpc.seb_test_vpc.id}"

    tags {
        Name = "NAT-seb_test"
    }
}

/* create instance */

data "aws_ami" "nat_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-pv*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_instance" "nat_seb_test" {
    ami = "${data.aws_ami.ubuntu.id}"
    availability_zone = "${var.aws_region}a"
    instance_type = "t2.micro"
    # instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.nat_sg.id}"]
    subnet_id = "${aws_subnet.seb_test_sn_public_a.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "VPC NAT seb_test"
    }
}
