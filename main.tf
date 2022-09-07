terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
  
    }
  }

  required_version = ">= 1.2.8"
}

terraform {
  cloud {
    organization = "terraform_fmt"

    workspaces {
      name = "terraform_fmt"
    }
  }
}

provider "aws" {
  region     = "eu-west-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_instance" "app_server" {
  count                  = 2
  ami                    = "ami-0d75513e7706cf2d9"
  instance_type          = "t2.micro"
  key_name               = "ec2-deployer-key-pair"
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "swinnytodd_Ec2"
  }
  connection {
    type    = "ssh"
    host    = self.public_ip
    user    = "ec2-user"
    timeout = "4m"
  }
}
resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}

resource "aws_key_pair" "deployer" {
  key_name   = "tls_private_key.cer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIRfHvMZnATojIL9Y0v/xMEZmfuX9pGT8J7EtKAljfAbTrSM7XA91ZxVP2YMV/HYBTYzR9S9WsjP63uUU+69sbt61YGsBVHERALLsomoQH2Ew9yqiPahh4BtHPmMJy/OaFIpn0CK7fZZJLNw/l/qa7TFY7/uRL9pzcf33TyoF6mSiE2+uPOt0gdua10pWnBBZODnqawWc5qUvMyFD1RyUcNSa2XTEfUJH54K7HAgpuKm1a9F3GHfDM+nO+tuWpxXxXoq+fp57CT52iVcYp3S0jS6MLtfAWjxtbvx2EWBgYFo3B7ZmQ/6Pud+AgM4xuPQpezHeDDV8P1pvAnta3TnHl0kcCBI4wS2S2T/yaojLNK7GyQXFfXARjdIoYoyaRc13zGUWCCWCftk33B3iUKVg6YQW8beVPsZKPIVi7m2/RoibpOdb9w+6CodbJMLZsyot5HP19yQlbctvTp8oz812O9Lv3Wetn0otxZrzWVQgktL7rAXk3aBZ4cLACsLqeeS0= admin@admins-MacBook-Pro.local"
}