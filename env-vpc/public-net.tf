
/*
  Public Subnet
*/
resource "aws_subnet" "seb_test_sn_public_a" {
    vpc_id = "${aws_vpc.seb_test_vpc.id}"

    cidr_block = "${var.public_subnet_a_cidr}"
    availability_zone = "${var.aws_region}a"

    tags {
        Name = "PublicSubnetA-seb-test"
    }
}

resource "aws_subnet" "seb_test_sn_public_b" {
    vpc_id = "${aws_vpc.seb_test_vpc.id}"

    cidr_block = "${var.public_subnet_b_cidr}"
    availability_zone = "${var.aws_region}b"

    tags {
        Name = "PublicSubnetB-seb-test"
    }
}


/* add route to public subnet */

/* ici on autorise le réseau "public" à accéder à la Gateway internet */

resource "aws_route_table" "seb_test_rt_public" {
    vpc_id = "${aws_vpc.seb_test_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.seb_test_igtw.id}"
    }

    tags {
        Name = "PublicSubnet-seb-test"
    }
}

resource "aws_route_table_association" "rta-public-a-seb-test" {
    subnet_id = "${aws_subnet.seb_test_sn_public_a.id}"
    route_table_id = "${aws_route_table.seb_test_rt_public.id}"
}


resource "aws_route_table_association" "rta-public-b-seb-test" {
    subnet_id = "${aws_subnet.seb_test_sn_public_b.id}"
    route_table_id = "${aws_route_table.seb_test_rt_public.id}"
}


/* ici la SG générique pour les instances dans le réseau public */

resource "aws_security_group" "seb_test_sg_public" {
    name = "vpc_web"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { //allow connection from inside VPC
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    ingress {
        from_port = 6443
        to_port = 6443
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    ingress {
        from_port = 6666
        to_port = 6666
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 65535
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.seb_test_vpc.id}"

    tags {
        Name = "WebServerSG"
    }
}
