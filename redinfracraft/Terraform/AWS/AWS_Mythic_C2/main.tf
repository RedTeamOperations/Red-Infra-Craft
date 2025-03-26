terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
  }
}


# AWS Provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

variable "access_key" {
  description = "AWS Access Key ID"
}

variable "secret_key" {
  description = "AWS Secret Access Key"
}

variable "region" {
  description = "AWS Region"
}

variable "key_name" {
  description = "EC2 secret file name"
}

variable "security_group" {
  description = "Security group for EC2 Instance creatted through Terraform."
  default = "Mythic_EC2_sg"
}


data "http" "my_ip" {
  url = "https://api.ipify.org?format=text"
}

locals {
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"
}


# Key Pair
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa-4096.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa-4096.private_key_pem
  filename = var.key_name
}


# EC2 Instance
resource "aws_instance" "Mythic_EC2" {
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.key_pair.key_name
  security_groups = [var.security_group]
  availability_zone = "us-east-1e"

  root_block_device {
    volume_size = 20  
    delete_on_termination = true
  }

  user_data = <<EOF
#!/bin/bash

sudo mkdir -p /home/ubuntu/access
cd /home/ubuntu/access

sudo apt-get update
sudo apt-get install -y git

sudo git clone https://github.com/its-a-feature/Mythic

cd /home/ubuntu/access/Mythic

sudo apt update
sudo apt install -y ca-certificates curl gnupg

# Create the keyrings directory (if not already created)
sudo mkdir -p /etc/apt/keyrings

# Download and add the Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo apt-get install -y make
sudo make

sudo /home/ubuntu/access/Mythic/mythic-cli install github https://github.com/MythicC2Profiles/http
sudo -E /home/ubuntu/access/Mythic/mythic-cli install github https://github.com/MythicAgents/Apollo.git

sudo /home/ubuntu/access/Mythic/mythic-cli start

EOF

  tags = {
    Name = "Mythic_EC2"
  }
}


# Security Group for EC2 Instance
resource "aws_security_group" "Mythic_EC2_sg" {
  name = var.security_group

  ingress {
    from_port   = 22
    to_port     = 22
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


# VPC
data "aws_vpc" "default" {
  default = true
}



# Output the public IP of the instance
output "instance_ip" {
  value = <<EOF
*******************************************************
| 🖥️ Machine Ip: ${aws_instance.Mythic_EC2.public_ip} |
*******************************************************
EOF
}

# Output the Username of the instance
output "username" {
  value = <<EOF
********************************** 
| 👤 Username of Machine: ubuntu |
**********************************
EOF
}

output "destroy_infra" {
  value = <<EOF
*******************************************************
| 🗑️	Command: redinfracraft.py destroy aws c2 mythic |
*******************************************************
EOF 
}