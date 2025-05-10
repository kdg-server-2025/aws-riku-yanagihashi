terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  backend "s3" {
    bucket = "kdg-aws-2025-yanagihashi"      
    key    = "terraform/state.tfstate"       
    region = "ap-northeast-1"                 #  東
    encrypt = true                            
  }
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

provider "aws" {
  region = "ap-northeast-1"  # ←デフォルトは東京
}
