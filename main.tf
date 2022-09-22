provider "aws" {
  profile = "terraform"
  region  = "us-east-1"
  access_key = "AKIAQQBQ2WVVNLQZFBW4"
  secret_key = "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"
}
# Security Group
variable "ingressrules" {
  type    = list(number)
  default = [8080, 22]
}
resource "aws_security_group" "web_traffic" {
  name        = "Allow web traffic"
  description = "inbound ports for ssh and standard http and everything outbound"
  dynamic "ingress" {iterator = port
    for_each = var.ingressrules
    content }
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Terraform" = "true"
  }
# Data Block
data "aws_ami" "redhat" {
  most_recent = true
  filter {
    name   = "name"
    values = ["RHEL-7.5_HVM_GA*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["309956199498"]
}
# resource block
resource "aws_instance" "test" {
  ami             = data.aws_ami.redhat.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_traffic.name]
}
