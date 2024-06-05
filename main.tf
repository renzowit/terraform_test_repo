terraform {
  backend "s3" {
    bucket = "rvh-tfstate"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "forge-vpc" {
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "Forge-VPC"
  }
}

resource "aws_subnet" "forge-subnet" {
  vpc_id     = aws_vpc.forge-vpc.id
  cidr_block = "192.168.1.0/28"
}

resource "aws_internet_gateway" "forge-gateway" {
  vpc_id = aws_vpc.forge-vpc.id

  tags = {
    Name = "forge-Gateway"
  }
}

resource "aws_security_group" "forge-sg" {
  name   = "Forge-SG"
  vpc_id = aws_vpc.forge-vpc.id

  dynamic "ingress" {
    for_each = var.sg_rules
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr"]
    }
  }
}

resource "aws_security_group" "forge2-sg" {
  name   = "Forge2-SG"
  vpc_id = aws_vpc.forge-vpc.id

  dynamic "ingress" {
    for_each = var.sg_rules
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr"]
    }
  }
}

resource "aws_instance" "forge1-ec2" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.forge-subnet.id
  vpc_security_group_ids = ["${aws_security_group.forge-sg.id}", "${aws_security_group.forge2-sg.id}"]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_instance" "forge2-ec2" {
  ami           = "ami-074254c177d57d640"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.forge-subnet.id

  tags = {
    Name = "Forge2-Instance"
  }
}