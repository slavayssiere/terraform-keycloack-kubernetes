
/*
  Private Subnet
*/
resource "aws_subnet" "seb_test_sn_private_a" {
    vpc_id = "${aws_vpc.seb_test_vpc.id}"

    cidr_block = "${var.private_subnet_a_cidr}"
    availability_zone = "${var.aws_region}a"

    tags {
        Name = "Private Subnet a"
    }
}

resource "aws_subnet" "seb_test_sn_private_b" {
    vpc_id = "${aws_vpc.seb_test_vpc.id}"

    cidr_block = "${var.private_subnet_b_cidr}"
    availability_zone = "${var.aws_region}b"

    tags {
        Name = "Private Subnet b"
    }
}


resource "aws_db_subnet_group" "seb_test_sng_bdd" {
  name       = "main"
  subnet_ids = ["${aws_subnet.seb_test_sn_private_a.id}","${aws_subnet.seb_test_sn_private_b.id}"]

  tags {
    Name = "My DB subnet group"
  }
}


/* add route table between private subnet and nat instance */

/* ici on permet aux deux reseaux internes de se connecter sur la vm nat*/

resource "aws_route_table" "seb_test_rt_private" {
    vpc_id = "${aws_vpc.seb_test_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat_seb_test.id}"
    }

    tags {
        Name = "Private Route Table"
    }
}

resource "aws_route_table_association" "seb_test_rta_private_a" {
    subnet_id = "${aws_subnet.seb_test_sn_private_a.id}"
    route_table_id = "${aws_route_table.seb_test_rt_private.id}"
}

resource "aws_route_table_association" "seb_test_rta_private_b" {
    subnet_id = "${aws_subnet.seb_test_sn_private_b.id}"
    route_table_id = "${aws_route_table.seb_test_rt_private.id}"
}

/* */

resource "aws_security_group" "seb_test_sg_private" {
    name = "vpc_db"
    description = "Allow incoming database connections from public network."

    ingress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = ["${aws_security_group.seb_test_sg_public.id}"]
    }

    ingress {
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
        Name = "PrivateServerSG"
    }
}

resource "aws_route53_zone" "seb_test_dns" {
  name = "seb.wescale"
  vpc_id = "${aws_vpc.seb_test_vpc.id}"

  tags {
    Name = "seb_test_dns"
  }
}
