
resource "aws_vpc" "seb_test_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags {
        Name = "aws-vpc-seb-test"
    }
}

resource "aws_internet_gateway" "seb_test_igtw" {
    vpc_id = "${aws_vpc.seb_test_vpc.id}"
}
