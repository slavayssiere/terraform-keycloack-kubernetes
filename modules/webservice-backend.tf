
resource "aws_instance" "private-ws-1" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  subnet_id = "${aws_subnet.eu-west-1a-private.id}"
  key_name = "${var.aws_key_name}"

  tags {
    Name = "vm-backend-ws"
  }
}