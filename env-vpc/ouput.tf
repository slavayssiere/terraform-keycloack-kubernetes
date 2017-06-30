
output "vm-nat" {
    value = "${aws_instance.nat_seb_test.public_dns}"
}