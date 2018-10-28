variable "aws-region" {
  default = "eu-central-1"
}

variable "aws-ami" {
  default = "ami-02724d1f"
}

variable "aws-ec2" {
  default = [
    "app01",
    "pgsql01",
    "pgsql02",
  ]
}
