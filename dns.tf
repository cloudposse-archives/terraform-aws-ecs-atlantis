resource "aws_route53_record" "default" {
  count   = "${local.enabled ? 1 : 0}"
  zone_id = "${var.parent_zone_id}"
  name    = "${var.short_name}"
  type    = "A"

  alias {
    name                   = "${var.alb_dns_name}"
    zone_id                = "${var.alb_zone_id}"
    evaluate_target_health = "false"
  }
}
