# Description: This file creates the load balancer and, target group for the ECS cluster, 
# and the listener for the load balancer


# Create an application load balancer
resource "aws_lb" "lb" {
    name               = "lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.lb_security_group.id]
    subnets            = aws_subnet.public_subnet[*].id
    tags = {
        Name = "lb"
    }
}

# Create a listener for the load balancer
resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn = aws_lb.lb.arn
    port              = 80
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.lb_target_group.arn
    }
}

# Create the target group for the load balancer
resource "aws_lb_target_group" "lb_target_group" {
    name        = "lb-target-group"
    port        = 80
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = aws_vpc.vpc.id
    health_check {
        healthy_threshold   = "3"
        interval            = "30"
        protocol            = "HTTP"
        timeout             = "3"
        unhealthy_threshold = "2"
        matcher             = "200"
        path                = "/"
    }
    tags = {
        Name = "lb_target_group"
    }
}

