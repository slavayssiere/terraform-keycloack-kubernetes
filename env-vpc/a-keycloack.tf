

resource "aws_instance" "seb_test_keycloack" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.seb_test_sg_public.id}"]
  subnet_id = "${aws_subnet.seb_test_sn_public_a.id}"
  key_name = "${var.aws_key_name}"
  associate_public_ip_address = true

  tags {
    Name = "vm-keycloack"
  }
}


resource "aws_route53_record" "keycloack_records" {
  zone_id = "${aws_route53_zone.seb_test_dns.zone_id}"
  name    = "keycloack.seb.wescale"
  type    = "A"
  ttl     = "30"

  records = [
    "${aws_instance.seb_test_keycloack.private_ip}"
  ]
}


resource "aws_instance" "seb_test_apache" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.seb_test_sg_public.id}"]
  subnet_id = "${aws_subnet.seb_test_sn_public_a.id}"
  key_name = "${var.aws_key_name}"
  associate_public_ip_address = true

  tags {
    Name = "vm-apache"
  }
}

resource "aws_route53_record" "apache_records" {
  zone_id = "${aws_route53_zone.seb_test_dns.zone_id}"
  name    = "apache.seb.wescale"
  type    = "A"
  ttl     = "30"

  records = [
    "${aws_instance.seb_test_apache.private_ip}"
  ]
}

