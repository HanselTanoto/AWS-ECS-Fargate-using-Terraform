# Description: This file contains the code to create an autoscaling policy for the ECS service


# Create an IAM role for ECS to use for autoscaling
# This role will be used by ECS to create, modify, and delete scaling policies for the application
resource "aws_iam_role" "autoscaling_role" {
    name = "autoscaling-role"
    assume_role_policy = <<EOF
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "sts:AssumeRole",
                    "Principal": {
                        "Service": "application-autoscaling.amazonaws.com"
                    },
                    "Effect": "Allow"
                }
            ]
        }
    EOF
}

# Attach the AmazonEC2ContainerServiceAutoscaleRole policy to the role
# This policy allows ECS to create, modify, and delete scaling policies for the application. 
resource "aws_iam_role_policy_attachment" "autoscaling_role_policy_attachment" {
    role       = aws_iam_role.autoscaling_role.id
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

# Create the target for the autoscaling policy 
# This target is the ECS service that we want to scale
resource "aws_appautoscaling_target" "ecs_service_target" {
    max_capacity       = 10
    min_capacity       = 1
    resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.service.name}"
    role_arn           = aws_iam_role.autoscaling_role.arn
    scalable_dimension = "ecs:service:DesiredCount"
    service_namespace  = "ecs"
}

# Create the autoscaling policy
# This policy will scale the ECS service up or down based on the target value
# The target value is the average number of requests per target
# The target value is set to 10 requests per target
resource "aws_appautoscaling_policy" "ecs_service_policy" {
    name               = "ecs-service-policy"
    policy_type        = "TargetTrackingScaling"
    resource_id        = aws_appautoscaling_target.ecs_service_target.resource_id
    scalable_dimension = aws_appautoscaling_target.ecs_service_target.scalable_dimension
    service_namespace  = aws_appautoscaling_target.ecs_service_target.service_namespace
    target_tracking_scaling_policy_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ALBRequestCountPerTarget"
            resource_label         = "app/${aws_lb.lb.name}/${basename("${aws_lb.lb.id}")}/targetgroup/${aws_lb_target_group.lb_target_group.name}/${basename("${aws_lb_target_group.lb_target_group.id}")}"
        }
        target_value = 10
    }
}

