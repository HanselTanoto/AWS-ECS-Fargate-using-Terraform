# Decription: This file creates the security groups for the ECS cluster and the Application Load Balancer


# Create Security Group for Application Load Balancer
resource "aws_security_group" "lb_security_group" {
    name        = "lb-security-group"
    description = "lb_security_group"
    vpc_id      = aws_vpc.vpc.id
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
}

# Create Security Group for ECS
resource "aws_security_group" "ecs_security_group" {
    name        = "ecs-security-group"
    description = "ecs_security_group"
    vpc_id      = aws_vpc.vpc.id
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        security_groups = [aws_security_group.lb_security_group.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

