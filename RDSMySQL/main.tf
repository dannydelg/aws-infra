provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
  
}

####################### Default VPC and Subnets ######################

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet" "subnet1" {
    vpc_id = data.aws_vpc.default.id
    availability_zone = "us-east-1a"
}

data "aws_subnet" "subnet2" {
    vpc_id = data.aws_vpc.default.id
    availability_zone = "us-east-1b"
}
 
# Creating a security group
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for RDS instance"
  vpc_id      = data.aws_vpc.default.id
 
  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


## Creating DB Subnet Group
resource "aws_db_subnet_group" "mydb_subnet_group" {
  name       = "mydb-subnet-group"
  subnet_ids = [
                data.aws_subnet.subnet1.id,
                data.aws_subnet.subnet2.id
                ]
  tags = {
    Name = "MyDBSubnetGroup"
  }
}

# Creating RDS Database Instance
resource "aws_db_instance" "myinstance" {
  engine               = "mysql"
  identifier           = "mydatabaseinstance"
  allocated_storage    = 20
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"  
  db_name              = "mydatabase"
  username             = "mydatabaseuser"
  password             = "mydatabasepassword"
  parameter_group_name = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name  = aws_db_subnet_group.mydb_subnet_group.name
  skip_final_snapshot  = true
  publicly_accessible  = true
}