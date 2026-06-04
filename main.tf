terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend is configured and deployed on the S3 Bucket

  backend "s3" {
    bucket = "umar-scratch-bucket-2026" # Your exact S3 bucket name here
    key    = "devops-scratch/terraform.tfstate" # This is the path
    region = "eu-north-1"                       
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. NEW BLOCK: Create the S3 Bucket for future State Storage
resource "aws_s3_bucket" "state_bucket" {
  bucket        = var.state_bucket_name
  force_destroy = true # This allows Terraform to cleanly delete the bucket later if needed

  tags = {
    Name = "DevOps-Scratch-State-Bucket"
  }
}

# 2. Create Security Group ( unchanged )
resource "aws_security_group" "web_sg" {
  name        = "scratch-project-sg"
  description = "Allow SSH and HTTP traffic"

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
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Spin up the Target Instance in eu-north-1 ( unchanged )
resource "aws_instance" "target_web_server" {
  ami                    = "ami-0014ce3e52359afbd" # Ubuntu 22.04 LTS for eu-north-1
  instance_type          = "t3.micro"
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "DevOps-Scratch-Target"
  }
}
