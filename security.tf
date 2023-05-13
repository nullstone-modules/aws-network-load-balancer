resource "aws_security_group" "lb" {
  name   = "${local.resource_name}/lb"
  vpc_id = local.vpc_id
  tags   = merge(local.tags, { Name = "${local.resource_name}/lb" })
}

resource "aws_security_group_rule" "lb-to-app" {
  security_group_id        = aws_security_group.lb.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = local.port
  to_port                  = local.port
  source_security_group_id = local.app_security_group_id
}

resource "aws_security_group_rule" "app-from-lb" {
  security_group_id        = local.app_security_group_id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = local.port
  to_port                  = local.port
  source_security_group_id = aws_security_group.lb.id
}
