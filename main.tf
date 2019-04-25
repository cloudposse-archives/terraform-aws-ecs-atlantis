terraform {
  required_version = ">= 0.10.7"
}

module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.2.1"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  attributes = "${var.attributes}"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "${module.default_label.id}"
  tags = "${module.default_label.tags}"
}

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
