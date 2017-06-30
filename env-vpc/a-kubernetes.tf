
resource "aws_instance" "seb_test_kubernetes" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.seb_test_sg_public.id}"]
  subnet_id = "${aws_subnet.seb_test_sn_public_a.id}"
  key_name = "${var.aws_key_name}"
  associate_public_ip_address = true

  # availability_zone = "${element(var.azs, count.index)}"

  count = 3
  tags {
    Name = "kubernetes-node-${count.index}"
  }
}

resource "aws_route53_record" "kubernetes_records" {
  zone_id = "${aws_route53_zone.seb_test_dns.zone_id}"
  name    = "kubernetes-${count.index}.seb.wescale"
  type    = "A"
  ttl     = "30"
  count = "${aws_instance.seb_test_kubernetes.count}"

  records = [
    "${element(aws_instance.seb_test_kubernetes.*.private_ip, count.index)}"
  ]
}

