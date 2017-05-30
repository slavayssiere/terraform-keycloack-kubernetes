
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

resource "aws_instance" "jahia-cms-1" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  subnet_id = "${aws_subnet.eu-west-1a-public.id}"
  key_name = "${var.aws_key_name}"
  associate_public_ip_address = true

  tags {
    Name = "vm-front"
  }
}

# resource "aws_eip" "jahia-1" {
#     instance = "${aws_instance.jahia-cms-1.id}"
#     vpc = true
# }


resource "aws_db_instance" "jahia-db" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.0.24"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "myusernameb4b"
  password             = "mypasswordb4b"
  db_subnet_group_name = "${aws_db_subnet_group.db-private.id}"
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  skip_final_snapshot = true

  tags {
        Name = "DB Jahia 1"
  }
}

