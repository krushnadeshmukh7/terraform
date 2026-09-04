resource "aws_s3_bucket" "my_bucket" {
  count = 10

  bucket = "krushna-s3-bucket-${count.index}"
}