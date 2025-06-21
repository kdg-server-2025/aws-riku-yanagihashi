provider "aws" {
  region = "ap-northeast-1"
  alias  = "tokyo"  # 東京リージョン用のエイリアス
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

