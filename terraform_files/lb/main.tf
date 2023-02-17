
resource "aws_alb" "alb-x" {
  name            = var.lb_name
  internal        = var.lb_internal_or_not
  security_groups = [var.lb-SGG]
  subnets         = var.lb_subnets_ids
}

resource "aws_alb_listener" "lb_listener" {
  load_balancer_arn = aws_alb.alb-x.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.lb_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "lb_target_group" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  # target_type = var.target_group_type
}

# resource "aws_alb_target_group_attachment" "nexus" {
#   target_group_arn = aws_alb_target_group.lb_target_group.arn

#   target_id = var.nexus_instance_id
#   port      = 8081
# }
resource "aws_alb_target_group_attachment" "sonarqube" {
  target_group_arn = aws_alb_target_group.lb_target_group.arn

  target_id = var.sonarqube_instance_id
  port      = 9000
}
