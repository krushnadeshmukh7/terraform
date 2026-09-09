resource "aws_instance" "myserver" {

  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  key_name      = "devops"

  tags = {
    Name = "terraform-server"
  }

}