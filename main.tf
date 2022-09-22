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
}
