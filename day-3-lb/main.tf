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
  name        = "day3-lb-sg-2"
  description = "Security group for Day 3 ALB"
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
    Name = "day3-lb-sg-2"
  }
}

# CREATE LOAD BALANCER
resource "aws_lb" "lb" {
  name               = "day3-alb-2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = data.aws_subnets.default.ids

  tags = {
    Name = "day3-alb-2"
  }
}

# CREATE TARGET GROUP
resource "aws_lb_target_group" "target_group" {
  name     = "day3-tg-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
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
  name_prefix   = "day3-web-"
  image_id      = "ami-090d68841c2a28756"
  key_name      = "krushna"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = filebase64("/root/terraform/day-3-lb/user_data.sh")
}

# CREATE AUTO SCALING GROUP
resource "aws_autoscaling_group" "ASG" {
  name                = "day3-asg-2"
  max_size            = 5
  min_size            = 2
  desired_capacity    = 2
  target_group_arns   = [aws_lb_target_group.target_group.arn]
  vpc_zone_identifier = data.aws_subnets.default.ids

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  health_check_type = "ELB"
}