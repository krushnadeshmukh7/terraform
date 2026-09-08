resource "aws_instance" "public_instance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.public_subnet_id
    vpc_security_group_ids = [var.sg_id]
    associate_public_ip_address = true
    user_data =file("/root/terraform/day-5-terraform-var-file/module/ec2/user_data.sh")
    tags = {
        Name = "public_instance"
        }
}

resource "aws_instance" "private_instance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.private_subnet_id
    vpc_security_group_ids = [var.sg_id]
    user_data = file("/root/terraform/day-5-terraform-var-file/module/ec2/user_data.sh")
    tags = {
        Name = "private_instance"
    }

}
