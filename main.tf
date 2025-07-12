terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "kdg-aws-2025-yanagihashi"
    key    = "terraform/state.tfstate"
    region = "ap-northeast-1"  # ← 東京リージョンの S3 を使う
    encrypt = true
  }
}
provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_db_instance" "rds_pg" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "17.4"
  instance_class       = "db.t4g.micro"
  db_name              = "mydb"
  username             = "adminuser"
  password             = "adminpassword123"
  parameter_group_name = "default.postgres17"
  skip_final_snapshot  = true
  publicly_accessible  = true
  deletion_protection  = false

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_security_group" "rds_sg" {
  name        = "allow-rds-access"
  description = "Allow PostgreSQL access from anywhere (not for production)"

  ingress {
    from_port   = 5432
    to_port     = 5432
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

