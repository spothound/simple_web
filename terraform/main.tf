terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

resource "aws_key_pair" "ansible" {
  key_name   = "ansible"
  public_key = file("ansible.pub")
}

provider "aws" {
  profile    = "default"
  region     = "us-west-2"
  access_key = file("aws_access_key")
  secret_key = file("aws_secret_key")
}

resource "aws_instance" "app_server" {
  ami           = "ami-0800fc0fa715fdcfe"
  instance_type = "t2.micro"
  key_name      = "ansible"
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