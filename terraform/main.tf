provider "aws" {
  access_key = "${file(".aws_access_key")}"
  secret_key = "${file(".aws_secret_key")}"
  region = "${var.aws-region}"
}

resource "aws_key_pair" "private_key" {
  key_name = "private_key"
  public_key = "${file("private_key.pub")}"
}

data "aws_availability_zones" "available" {}


resource "aws_security_group" "ssh" {
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http" {
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "pgsql" {
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "local_file" "foo" {
    filename = "../ansible/inventory_aws"
    content = <<EOF
[all:vars]
ansible_connection=ssh
ansible_user=admin
ansible_ssh_pipelining=true
ansible_ssh_private_key_file=../terraform/private_key

[app]
app01.paxful.lo ansible_host=${aws_instance.app01.public_ip}

[pgsql:children]
pgsql-master
pgsql-slave

[pgsql-master]
pgsql01.paxful.lo ansible_host=${aws_instance.pgsql01.public_ip}

[pgsql-slave]
pgsql02.paxful.lo ansible_host=${aws_instance.pgsql02.public_ip}
EOF
}
