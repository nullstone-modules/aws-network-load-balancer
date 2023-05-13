resource "aws_route53_record" "alias" {
  count = local.subdomain_zone_id != "" ? 1 : 0

  zone_id = local.subdomain_zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = false
  }
}
