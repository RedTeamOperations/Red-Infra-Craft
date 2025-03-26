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
  default = "terra_ec2_sg"
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
resource "aws_instance" "Terra_Ec2" {
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.Terra_Ec2_sg.id]
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
    Name = "Terra_EC2"
  }
}


# Security Group for EC2 Instance
resource "aws_security_group" "Terra_Ec2_sg" {
  name = var.security_group

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
    security_groups = [aws_security_group.terraElbSg.id]
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


# Target Group
resource "aws_lb_target_group" "TerraEC2Tg" {
  name        = "TerraEC2Tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "TerraEC2TgAttach" {
  target_group_arn = aws_lb_target_group.TerraEC2Tg.arn
  target_id = aws_instance.Terra_Ec2.id
  port = 80
}


# Subnet
data "aws_subnets" "GetSubnet" {
  
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "availability-zone"
    values = [aws_instance.Terra_Ec2.availability_zone, "us-east-1a"] 
  }                                               
}


# Load Balancer
resource "aws_lb" "terraElb" {
  name               = "terraElb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraElbSg.id]
  subnets            = data.aws_subnets.GetSubnet.ids
  tags ={
    Name = "terraElb"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.terraElb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    forward {
      target_group{
        arn = aws_lb_target_group.TerraEC2Tg.arn
      }
    }   
  }
}


# Security Group for Load Balancer
resource "aws_security_group" "terraElbSg" {
  name = "Allow http traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
         from_port   = 80
         to_port     = 80
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


# CloudFront
resource "aws_cloudfront_distribution" "my_cloudfront_distribution" {
  origin {
    domain_name = aws_lb.terraElb.dns_name  # Use the DNS name of the Load Balancer as the origin
    origin_id   = "my-load-balancer-origin"  # Set a unique ID for the origin
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "My CloudFront Distribution"
  default_root_object = "index.html"

  # Define default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "my-load-balancer-origin"  # Use the same origin ID as defined above
    viewer_protocol_policy = "allow-all"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  # Define viewer certificate (if using HTTPS)
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  
  # Define restrictions, if needed (e.g., whitelist IP addresses)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}



# Output the public IP of the instance
output "instance_ip" {
  value = <<EOF
******************************************************
| 🖥️ Machine Ip: ${aws_instance.Terra_Ec2.public_ip} |
******************************************************

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

# Output the Domain of the CloudFront
output "cloudfront_domain_name" {
  value = <<EOF
***********************************************************************************************
| 🌍 CloudFront Domain: ${aws_cloudfront_distribution.my_cloudfront_distribution.domain_name} |
***********************************************************************************************
EOF
}


output "destroy_infra" {
  value = <<EOF
*********************************************************
| 🗑️	Command: redinfracraft.py destroy aws c2 mythic_lb |
*********************************************************
EOF 
}