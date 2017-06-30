provider "aws" {
}

# module "b4b-demo" {
#   source = "b4b-env"

#   aws_key_name = "slavayssiere_b4b"
#   aws_key_path = "/Users/sebastienlavayssiere/.ssh/slavayssiere_b4b.pem"

#   aws_region   =  "eu-west-1"
# }

module "env-vpc" {
  source = "env-vpc"

  aws_key_name = "slavayssiere"
  aws_key_path = "/Users/sebastienlavayssiere/.ssh/slavayssiere_frankfurt.pem"

  aws_region   =  "eu-central-1"
}

# output "consul-lb" {
#   value = "${module.b4b-demo.consul_lb}"
# }

# output "vm-nat" {
#     value = "${module.b4b-demo.vm-nat}"
# }