provider "aws" {
  region = "us-east-1"
}
#terraform {
#  required_providers {
#    azurerm = {
#      source  = "hashicorp/azurerm"
#      version = "~> 3.0.2"
#    }
#  }
#}

terraform {
  cloud {
    organization = "batch15"

    workspaces {
      name = "myws"
    }
  }
}

variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#variable security_group_name {
#  type= string
#  default = "jenkins"
#}

data "aws_security_group" "lb_sg" {
  name = "jenkins"
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.lb_sg.id]
  tags = {
    Name = "HelloWorld"
  }
}
