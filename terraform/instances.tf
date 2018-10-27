resource "aws_instance" "app01" {
  ami                         = "${var.aws-ami}"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name = "private_key"
  vpc_security_group_ids = [ "${aws_security_group.ssh.id}", "${aws_security_group.http.id}" ]
  # private_ip    = "${var.private_ips[count.index]}"
}

resource "aws_instance" "pgsql01" {
  ami                         = "${var.aws-ami}"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name = "private_key"
  vpc_security_group_ids = [ "${aws_security_group.ssh.id}", "${aws_security_group.http.id}", "${aws_security_group.pgsql.id}" ]
  # private_ip    = "${var.private_ips[count.index]}"
}

resource "aws_instance" "pgsql02" {
  ami                         = "${var.aws-ami}"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name = "private_key"
  vpc_security_group_ids = [ "${aws_security_group.ssh.id}", "${aws_security_group.http.id}", "${aws_security_group.pgsql.id}" ]
  # private_ip    = "${var.private_ips[count.index]}"
}
