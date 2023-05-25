// Security works differently for Network Load Balancers
// You cannot attach a security group to a network load balancer
// See https://docs.aws.amazon.com/elasticloadbalancing/latest/network/target-group-register-targets.html#target-security-groups

resource "aws_security_group_rule" "app-from-world" {
  security_group_id = local.app_security_group_id
  type              = "ingress"
  protocol          = "-1"
  from_port         = local.port
  to_port           = local.port
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  protocol          = var.protocol
  port              = local.port
  tags              = local.tags

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
