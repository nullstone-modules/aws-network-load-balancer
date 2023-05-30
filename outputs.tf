output "load_balancers" {
  value = [
    for tg in aws_lb_target_group.this : {
      port             = tg.port
      target_group_arn = tg.arn
    }
  ]
}

locals {
  protocol = lower(var.protocol)

  lb_subdomain = aws_lb.this.dns_name
  lb_urls      = [for _, port in local.all_ports : "${local.protocol}://${local.lb_subdomain}:${port}"]

  vanity_subdomain = try(trimsuffix(aws_route53_record.alias[0].fqdn, "."), "")
  vanity_urls      = [for _, port in local.all_ports : "${local.protocol}://${local.vanity_subdomain}:${port}"]

  // Technically, we should always be able to hit the load balancer url directly
  // Let's return the vanity URL if we have one so the user is set up for success
  public_urls = local.subdomain_zone_id != "" ? [for vanity_url in local.vanity_urls : { url = vanity_url }] : [for lb_url in local.lb_urls : { url = lb_url }]
}

output "public_urls" {
  value = local.public_urls
}
