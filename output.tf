# Description: This file will output the DNS name of the load balancer to the console


data "aws_lb" "lb" {
    arn = aws_lb.lb.arn
}

# Output the DNS name of the load balancer
output "aws_lb_hostname" {
    value = data.aws_lb.lb.dns_name
}

