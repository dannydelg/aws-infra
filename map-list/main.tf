provider "aws" {
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
  
}

resource "aws_instance" "DannyEC2" {
    ami             = "ami-01cc34ab2709337aa"
    instance_type   = var.myTypes["micro"] // var.ec2list[2] 
  
}

variable "ec2list" {
    type = list(string)
    default = [ "m5.large", "m5.xlarge", "t2.micro" ] 
}

variable "myTypes" {
    type = map(string)
    default = {
      "micro" = "t2.micro"
      "small" = "t2.small"
      "medium" = "t2.medium"
    }
}

