terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

resource "aws_key_pair" "test" {
  key_name   = "test"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChAuN3EpJjAYcF1FoAEVN1smJvPJvqeRqBEFhgbjfn9cSMaB35Puygs8qQT5VNxdhfSDQUsLOl1kxrNK1+w92VCuQ1zqJR5C7rbnAvYvCUsgSiXCzkFRz1tjIO4fJ4nt1QvqMYyIROdkA6+srLgbpeNmJpL9m9LWJ58bA5pnpOI4kIg84Dy52FOn93cXRJF+csN/+2gJrWuaULLitBnoM+kbBv+7S4lJ7r8NvmNUwePBNGPOL26dvMbD3n1hP8DKR2HWQdIeE1O+pd3Uf+W2f3Xc2gDuviPhEj3bZoHtegMlH7Y1lcRFwCuGrNRAlZGU9dMqLO3LQACgU7XbkUtkd37O4H+TCi8lOlODz2M8iaHTCfDSJE8/BSV/3jcRroyCTwkLQ687pXJIviPMJtJ2FpRTu8kD4cEXodCnqoH8oLY7rYr7bk1XQRL6EZJoIzgrhbLoDczVuMwV/6d/ISzsdU8NnXlPXqfNGyhPLtsfzae6PXbo1G7B3Lfl+OIwQzaiU= grg121@archlinux"
}

provider "aws" {
  profile    = "default"
  region     = "us-west-2"
  access_key = "AKIAU7V2EO6JBCTCDLH5"
  secret_key = "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"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0800fc0fa715fdcfe"
  instance_type = "t2.micro"
  key_name      = "default"
  tags = {
    Name = "dev w devops simple_web"
  }
  vpc_security_group_ids = [
    aws_security_group.web_server.id
  ]
}

output "address" {
  value = aws_instance.app_server.*.public_dns
}

resource "aws_security_group" "web_server" {
  name        = "web-server-security-group"
  description = "Allow HTTP, HTTPS and SSH traffic"

  # It would be more secure to allow SSH traffic only from private networks but
  # in the interest of simplicity we will keep this unsecure for this exercise

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform"
  }
}