provider "aws" {
  access_key = "${file(".aws_access_key")}"
  secret_key = "${file(".aws_secret_key")}"
  region     = "${var.aws-region}"
}

resource "aws_key_pair" "private_key" {
  key_name   = "private_key"
  public_key = "${file("private_key.pub")}"
}

data "aws_availability_zones" "available" {}

data "aws_vpc" "available" {}

resource "aws_subnet" "private" {
  vpc_id            = "${data.aws_vpc.available.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block        = "${cidrsubnet(data.aws_vpc.available.cidr_block, 8, 250)}"
}

resource "aws_security_group" "default" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.private.cidr_block}"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.private.cidr_block}"]
  }
}

resource "aws_instance" "instances" {
  count                       = "${length(var.aws-ec2)}"
  ami                         = "${var.aws-ami}"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "private_key"
  subnet_id                   = "${aws_subnet.private.id}"
  vpc_security_group_ids      = ["${aws_security_group.default.id}"]

  tags = {
    name = "${var.aws-ec2[count.index]}"
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
app01.paxful.lo ansible_host=${aws_instance.instances.0.public_ip}

[pgsql:children]
pgsql-master
pgsql-slave

[pgsql-master]
pgsql01.paxful.lo ansible_host=${aws_instance.instances.1.public_ip}

[pgsql-slave]
pgsql02.paxful.lo ansible_host=${aws_instance.instances.2.public_ip}
EOF
}
