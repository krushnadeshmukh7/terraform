resource "aws_instance" "ec2" {
    for_each = tomap({
        krushna-1 = "c7i-flex.large"
        krushna-2 = "t3.micro"
    })

    ami = "ami-01a00762f46d584a1"
    instance_type = each.value
    key_name = "devops"
    tags = {
        Name = each.key
    }
  
}