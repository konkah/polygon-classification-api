resource "aws_alb" "polygon_load_balancer" {
  name               = "polygon-load-balancer-prod" #load balancer name
  load_balancer_type = "application"
  subnets = [ # Referencing the default subnets
    "${aws_default_subnet.polygon_default_subnet_1.id}",
    "${aws_default_subnet.polygon_default_subnet_2.id}"
  ]
  # security group
  security_groups = ["${aws_security_group.polygon_lb_security_group.id}"]
}

# Create a security group for the load balancer:
resource "aws_security_group" "polygon_lb_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic in from all sources
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "polygon_lb_target_group" {
  name        = "polygon-lb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_default_vpc.polygon_default_vpc.id}" # default VPC
}

resource "aws_lb_listener" "polygon_lb_listener" {
  load_balancer_arn = "${aws_alb.polygon_load_balancer.arn}" #  load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.polygon_lb_target_group.arn}" # target group
  }
}
