# Description: This Terraform script creates an ECS cluster with container insights enabled, 
# a task definition for the nginx container, and an ECS service with the task definition. 
# The ECS service is configured to use the Application Load Balancer created in the previous script.


# Create an ECS cluster with container insights enabled
resource "aws_ecs_cluster" "main" {
  name = "main"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Create a task definition for the nginx container
resource "aws_ecs_task_definition" "task" {
    family                   = "nginx-service"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = "256"
    memory                   = "1024"
    container_definitions    = <<DEFINITION
    [
        {
            "name": "nginx",
            "image": "nginx:1.23.1",
            "cpu": 256,
            "memory": 1024,
            "portMappings": [
                {
                    "containerPort": 80,
                    "hostPort": 80,
                    "protocol": "tcp"
                }
            ],
            "essential": true
        }
    ]
    DEFINITION
}

# Create an ECS service with the task definition 
resource "aws_ecs_service" "service" {
    name            = "nginx-service"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.task.id
    launch_type     = "FARGATE"
    force_new_deployment = true
    network_configuration {
        subnets          = aws_subnet.private_subnet[*].id
        security_groups  = [aws_security_group.lb_security_group.id, aws_security_group.ecs_security_group.id]
        assign_public_ip = false
    }
    load_balancer {
        target_group_arn = aws_lb_target_group.lb_target_group.arn
        container_name   = "nginx"
        container_port   = 80
    }
    depends_on = [aws_lb_listener.lb_listener]
}

