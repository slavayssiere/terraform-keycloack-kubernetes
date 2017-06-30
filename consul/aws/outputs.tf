output "server_address" {
    value = "${aws_instance.server.0.public_dns}"
}

output "consul_lb" {
    value = "${aws_elb.consul_lb.dns_name}"
}
