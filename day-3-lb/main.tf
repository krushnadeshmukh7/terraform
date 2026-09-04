data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# CREATE SECURITY GROUP
resource "aws_security_group" "sg" {
  name        = "my_sg"
  description = "my_sg"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_sg"
  }
}

# CREATE LOAD BALANCER
resource "aws_lb" "lb" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = data.aws_subnets.default.ids

  tags = {
    Name = "ALB"
  }
}

# CREATE TARGET GROUP
resource "aws_lb_target_group" "target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

# CREATE LOAD BALANCER LISTENER
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# CREATE LAUNCH TEMPLATE
resource "aws_launch_template" "lt" {
  name_prefix   = "web_template"
  image_id      = "ami-0c55b159cbfafe1f0"
  key_name      = "krushna"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = filebase64("/root/terraform/day-3-lb/user_data.sh")
}

resource "aws_autoscaling_group" "ASG" {
    name = "Ags"
    max_size = 5
    min_size = 2
    desired_capacity = 2
    target_group_arns = [aws_lb_target_group.target_group.arn]
    vpc_zone_identifier = data.aws_subnets.default.ids

    launch_template {
        id = aws_launch_template.lt.id
        version = "$Latest"  
    }
    health_check_type = "ELB"
}