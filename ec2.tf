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

  owners = ["099720109477"] # Canonical (Ubuntu)
}

resource "aws_instance" "kdg_aws_20250621_userdata" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "AmazonLinuxKeyPare" # SSH

  tags = {
    Name     = "kdg-aws-20250621-userdata"
    UserDate = "true"
  }

  user_data_replace_on_change = true

  user_data_base64 = base64encode(<<EOF
#!/usr/bin/env bash
set -Ceux
set -o pipefail

GITHUB_USERNAME="riku-yanagihashi"
wget "https://github.com/$GITHUB_USERNAME.keys" -O /home/ubuntu/.ssh/authorized_keys

mkdir -p /home/ubuntu/.ssh/
chmod 700 /home/ubuntu/.ssh/
chown ubuntu:ubuntu /home/ubuntu/.ssh/
chmod 600 /home/ubuntu/.ssh/authorized_keys
chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys
EOF
  )
}
