provider "aws" {
}

module "b4b-demo" {
  source = "modules"

  aws_key_name = "slavayssiere_b4b"
  aws_key_path = "/Users/sebastienlavayssiere/.ssh/slavayssiere_b4b.pem"

  aws_region   =  "eu-west-1"
}

output "consul-lb" {
  value = "${module.b4b-demo.consul-lb}"
}

output "vm-nat" {
    value = "${module.b4b-demo.vm-nat}"
}