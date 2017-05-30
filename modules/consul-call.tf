

module "consul" {
  source = "../consul/aws"

  key_name = "slavayssiere_b4b"
  key_path = "/Users/sebastienlavayssiere/.ssh/slavayssiere_b4b.pem"
  region   =  "eu-west-1"

  my_public_security_group_ids = "${aws_security_group.web.id}"
  my_public_subnet_id = "${aws_subnet.eu-west-1a-public.id}"
  my_vpc_id = "${aws_vpc.vpc_b4b.id}"
  servers  = "3"
}

output "consul_address" {
    value = "${module.consul.server_address}"
}

