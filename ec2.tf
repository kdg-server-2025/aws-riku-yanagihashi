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

# resource "aws_instance" "kdg_aws_20250621_userdata" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
#   key_name      = "AmazonLinuxKeyPare" # SSH
#   vpc_security_group_ids = [aws_security_group.allow_ssh.id] 
#
#   associate_public_ip_address = true
#
#   tags = {
#     Name     = "kdg-aws-20250621-userdata"
#     UserDate = "true"
#   }
#
#   user_data_replace_on_change = true
#
#   user_data_base64 = base64encode(<<EOF
#
# EOF
#   )
# }

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_v2"
  description = "Allow SSH access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_vpc" "default" {
  default = true
}
