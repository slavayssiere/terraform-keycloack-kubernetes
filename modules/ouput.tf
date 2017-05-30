
output "consul-lb" {
  value = "${module.consul.consul-lb}"
}

output "vm-nat" {
    value = "${aws_instance.nat.public_dns}"
}