resource "aws_instance" "example" {
  instance_type          = "t3.micro"
  ami                    = "ami-08188a5a4dfdbd573"
  key_name               = "devops"
  count                  = 2
  vpc_security_group_ids = ["sg-0803c5030f66d2f4f"]

  provisioner "file" {
    source      = "hello.txt"
    destination = "/home/ec2-user/hello.txt"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/devops.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}