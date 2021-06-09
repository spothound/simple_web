# This stack assumes that a Default VPC is present

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20151015"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "webserver" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.key_name}"
  vpc_security_group_ids = [ "${aws_security_group.instance.id}" ]
  user_data       = "${file("userdata.sh")}"
  lifecycle {
    create_before_destroy = true
  }

  provisioner "file" {
    source      = "upload/index.html"
    destination = "/tmp/index.html"
    connection {
      host = "${aws_instance.webserver.public_ip}"
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file("kenopsy.pem")}"
      timeout = "2m"
    }
  }

}

resource "aws_security_group" "instance" {
  name = "test-sg"
  description = "Allow traffic for instances"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
