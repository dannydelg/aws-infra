provider "aws" {
  region     = "us-east-1"
  access_key = "ENTER YOUR ACCES KEY"
  secret_key = "ENTRE YOUR SECRET ACCES KEY"

}


variable "ports" {
  type    = list(number)
  default = [22, 80, 8201, 8202]

}

resource "aws_security_group" "sg_dinamic-block" {
  name = "my-security-group"
  dynamic "ingress" {
    for_each = var.ports
    iterator = port
    content {

      from_port   = port.value
      to_port     = port.value
      protocol    = port.value == 22 ? "ssh" : "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }

  }

}
