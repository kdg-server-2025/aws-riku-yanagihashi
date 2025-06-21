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
