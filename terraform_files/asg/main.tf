# resource "aws_launch_template" "instance-template" {
#   name = "launch-template-x"
#   image_id = var.img_id
#   instance_type = var.instance_type
#   key_name = var.key_pair_name

#     network_interfaces {
#     security_groups  = [var.ASG_LT_SG]
#     associate_public_ip_address = var.pub_ip_state_ASG
#     }

#     lifecycle {
#         create_before_destroy = true
#     }

#   user_data = filebase64("./public.sh")

# #  provisioner "remote-exec" {
# #           inline = var.remote_commands
  
# #         connection {
# #             host        = aws_autoscaling_group.ASG.instances[*].public_ip
# #             # host = var.pub_ip_state ? self.public_ip : self.private_ip
# #             type        = "ssh"
# #             user        = "ubuntu"
# #             private_key = file("lab4.pem")
# #         }
       
# #     }
# #     depends_on = [
# #       aws_autoscaling_group.ASG
# #     ]


#     tag_specifications {
#         resource_type = "instance"
#          tags = {
#       Name = "test"
#     } 
#   }
# }

# resource "aws_autoscaling_group" "ASG" {
#     name = var.ASG_name
#     min_size = 2
#     desired_capacity = 2
#     max_size = 5
#     health_check_grace_period = 300
#     vpc_zone_identifier = var.ASG_subnets_id
#     target_group_arns = var.TG_arn

#     launch_template  {
#         id = aws_launch_template.instance-template.id
#         version = var.instance_template_version
#     }
#     depends_on = [var.depends]
# }

# # resource "aws_autoscaling_policy" "scale_up" {
# #   name = var.policy_name
# #   autoscaling_group_name = aws_autoscaling_group.ASG
# #   adjustment_type = "ChangeInCapacity"
# #   scaling_adjustment = var.scaling_adjustment
# #   cooldown = "300"
# #   policy_type = "SimpleScaling"
# # }


# # # scale up alarm
# # # alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
# # resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
# #   alarm_name          = "asg-scale-up-alarm"
# #   alarm_description   = "asg-scale-up-cpu-alarm"
# #   comparison_operator = "GreaterThanOrEqualToThreshold"
# #   evaluation_periods  = "2"
# #   metric_name         = "CPUUtilization"
# #   namespace           = "AWS/EC2"
# #   period              = "120"
# #   statistic           = "Average"
# #   threshold           = "30" # New instance will be created once CPU utilization is higher than 30 %
# #   dimensions = {
# #     "AutoScalingGroupName" = aws_autoscaling_group.ASG.name
# #   actions_enabled = true
# #   alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
# # }

# # # scale down policy
# # resource "aws_autoscaling_policy" "scale_down" {
# #   name                   = "asg-scale-down"
# #   autoscaling_group_name = aws_autoscaling_group.ASG.name
# #   adjustment_type        = "ChangeInCapacity"
# #   scaling_adjustment     = "-1" # decreasing instance by 1 
# #   cooldown               = "300"
# #   policy_type            = "SimpleScaling"
# # }

# # # scale down alarm
# # resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
# #   alarm_name          = "asg-scale-down-alarm"
# #   alarm_description   = "asg-scale-down-cpu-alarm"
# #   comparison_operator = "LessThanOrEqualToThreshold"
# #   evaluation_periods  = "2"
# #   metric_name         = "CPUUtilization"
# #   namespace           = "AWS/EC2"
# #   period              = "120"
# #   statistic           = "Average"
# #   threshold           = "5" # Instance will scale down when CPU utilization is lower than 5 %
# #   dimensions = {
# #     "AutoScalingGroupName" = aws_autoscaling_group.this.name
# #   }
# #   actions_enabled = true
# #   alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
# # }