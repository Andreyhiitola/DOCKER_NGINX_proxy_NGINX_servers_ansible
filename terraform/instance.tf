resource "aws_instance" "web-server" {

  ami             = "ami-065deacbcaac64cf2"
  instance_type   = "t2.micro"
  count           = 1 
  key_name        = "mykeypair"
  security_groups = ["${aws_security_group.web-server.name}"]

  tags = {
    NAME = "instance-${count.index}"
  }
}
