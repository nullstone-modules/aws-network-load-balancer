resource "aws_security_group_rule" "lb-from-world" {
  security_group_id = aws_security_group.lb.id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "-1"
  from_port         = local.port
  to_port           = local.port
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
