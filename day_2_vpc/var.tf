variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "0,0.0.0/16"
} 

variable "public_cidr" {
  description = "CIDR block for the public subnet"
  default     = "0,0.0.0/20"
}

vairable "private_cidr" {
  description = "CIDR block for the private subnet"
  default     = "0,0.0.0/20"
}

variable "public_az" {
  description = "Availability zone for the public subnet"
  default     = "us-east-1a"
}

variable "private_az" {
  description = "Availability zone for the private subnet"
  default     = "us-east-1b"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
   default = "ami-0bea529386a62a2ad"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for the EC2 instance"
  default     = "sarika"
}

vairable "volume_size" {
  description = "Size of the EBS volume in GB"
  default     = 10
}

vairable "volume_type" {
  description = "Type of the EBS volume"
  default     = "gp3"
}