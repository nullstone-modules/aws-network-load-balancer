resource "aws_lb_target_group" "this" {
  name                 = "${local.resource_name}-${local.port}"
  port                 = local.port
  protocol             = var.protocol
  target_type          = "ip"
  vpc_id               = local.vpc_id
  deregistration_delay = 10
  tags                 = local.tags

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    interval            = var.health_check_interval
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    enabled             = var.health_check_enabled
    timeout             = var.health_check_timeout
    protocol            = var.protocol
  }
}
