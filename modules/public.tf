
resource "aws_security_group" "web" {
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
    ingress { # for Consul
        from_port = 8500
        to_port = 8500
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { # for Consul
        from_port = 8600
        to_port = 8600
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # egress { # MySQL
    #     from_port = 3306
    #     to_port = 3306
    #     protocol = "tcp"
    #     cidr_blocks = ["${var.private_subnet_cidr}"]
    # }

    vpc_id = "${aws_vpc.vpc_b4b.id}"

    tags {
        Name = "WebServerSG"
    }
}
