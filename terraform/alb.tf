# target  group
resource "aws_lb_target_group" "target_group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "whiz-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.default.id
}

#Creating aws_alb
resource "aws_lb" "application-lb" {
  name               = "whiz-alb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-server.id]
  subnets            = data.aws_subnet_ids.subnet.ids

  tags = {
    Name = "whiz-alb"
  }

}
# Creating listener
resource "aws_lb_listener" "HTTP" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}
resource "aws_lb_listener" "HTTPS" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = 443
  protocol          = "HTTPS"
  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}

#attachment
resource "aws_lb_target_group_attachment" "ec2_attach" {
  count            = length(aws_instance.web-server)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.web-server[count.index].id
}
