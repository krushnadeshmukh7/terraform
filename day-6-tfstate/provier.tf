provider "aws" {
    region = "ap-east-1"
    profile = "dev"
  
}

terraform {
  backend "s3" {
    bucket = "krushna-s3-123123"
    region = "ap-east-1"
    profile = "dev"
    use_lockfile = true
    key = "terraform.tfstate"
    shared_credentials_files = ["/root/.aws/credentials"]
  }
}