output "server_address" {
    value = "${aws_instance.server.0.public_dns}"
}

output "consul-lb" {
    value = "${aws_elb.consul-lb.public_dns}"
}
