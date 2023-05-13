resource "aws_lb" "this" {
  name               = local.resource_name
  internal           = false
  load_balancer_type = "network"
  subnets            = local.subnet_ids
  security_groups    = [aws_security_group.lb.id]
  ip_address_type    = "ipv4"
  tags               = local.tags

  access_logs {
    bucket  = module.logs_bucket.bucket_id
    enabled = true
  }
}
