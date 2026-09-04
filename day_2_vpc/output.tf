output "pubic_ip" {
  value = aws_instance.web.public_ip
}

output  "elastic_ip" {
  value = aws_eip.nat_eip.public_ip
}

output "sg_id" {
  value = aws_vpc.my_vpc.id
}