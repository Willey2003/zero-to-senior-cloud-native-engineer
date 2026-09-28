terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  # Step 2 of the lab: move state to S3 with locking.
  # backend "s3" {
  #   bucket       = "my-tf-state-<unique>"
  #   key          = "lab06/terraform.tfstate"
  #   region       = "ap-south-1"
  #   use_lockfile = true
  # }
}

provider "aws" {
  region = var.region
  default_tags { tags = { Project = "zero-to-cloud-native", Lab = "06" } }
}

module "vpc" {
  source      = "./modules/vpc"
  name        = "lab06"
  cidr        = "10.60.0.0/16"
  azs         = ["${var.region}a", "${var.region}b"]
  enable_nat  = false # NAT gateways cost money; enable only when testing private egress
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "web" {
  name   = "lab06-web"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "HTTP from my IP only"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.web.id]
  metadata_options { http_tokens = "required" } # IMDSv2 only: a real security best practice
  user_data = <<-EOT
    #!/bin/bash
    dnf install -y nginx
    echo "<h1>Hello from $(hostname) built by Terraform</h1>" > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOT
  tags = { Name = "lab06-web" }
}
