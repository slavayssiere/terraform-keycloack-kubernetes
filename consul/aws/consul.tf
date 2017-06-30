resource "aws_instance" "server" {
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.servers}"
    vpc_security_group_ids = ["${aws_security_group.consul.id}"] # , "${var.my_public_security_group_ids}"
    subnet_id = "${var.my_public_subnet_id}"
    associate_public_ip_address = true
    source_dest_check = false

    connection {
        user = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }

    #Instance tags
    tags {
        Name = "${var.tagName}-${count.index}"
        ConsulRole = "Server"
    }

    provisioner "file" {
        source = "${path.module}/../shared/scripts/${lookup(var.service_conf, var.platform)}"
        destination = "/tmp/${lookup(var.service_conf_dest, var.platform)}"
    }


    provisioner "remote-exec" {
        inline = [
            "echo ${var.servers} > /tmp/consul-server-count",
            "echo ${aws_instance.server.0.private_dns} > /tmp/consul-server-addr",
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../shared/scripts/install.sh",
            "${path.module}/../shared/scripts/service.sh",
            "${path.module}/../shared/scripts/ip_tables.sh",
        ]
    }
}

# resource "aws_eip" "consul-ip" {
#     count = "${var.servers}"
#     instance = "${element(aws_instance.server.*.id, count.index)}"
#     vpc = true
# }

resource "aws_elb" "consul_lb" {
  name               = "ui-consul-elb"
  security_groups = ["${var.my_public_security_group_ids}", "${aws_security_group.consul.id}"]
  subnets = ["${var.my_public_subnet_id}"]

  listener {
    instance_port     = 8500
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8600
    instance_protocol  = "http"
    lb_port            = 8600
    lb_protocol        = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8500/v1/health/state/passing"
    interval            = 30
  }

  instances                   = ["${aws_instance.server.*.id}"]

  tags {
    Name = "ui-consul-elb"
  }
}


resource "aws_security_group" "consul" {
    name = "consul_${var.platform}"
    description = "Consul internal traffic + maintenance."

    // These are for internal traffic
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
    }

    // These are for maintenance
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${var.my_vpc_id}"
}
