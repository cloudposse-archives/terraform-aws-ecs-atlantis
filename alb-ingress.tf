locals {
  target_group_enabled = "${local.enabled && var.target_group_arn == "" ? "true" : "false"}"
  target_group_arn     = "${local.target_group_enabled == "true" ? aws_lb_target_group.default.arn : var.target_group_arn}"
}

data "aws_lb_target_group" "default" {
  arn = "${local.target_group_arn}"
}

module "lb_target_group_label" {
  enabled    = "${local.target_group_enabled}"
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.2.1"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

locals {
  supported_authentication_actions = {
    "COGNITO" = {
      type = "authenticate-cognito"

      authenticate_cognito = [{
        user_pool_arn       = "${var.authentication_cognito_user_pool_arn}"
        user_pool_client_id = "${var.authentication_cognito_user_pool_client_id}"
        user_pool_domain    = "${var.authentication_cognito_user_pool_domain}"
      }]
    }

    "OIDC" = {
      type = "authenticate-oidc"

      authenticate_oidc = [{
        client_id              = "${var.authentication_oidc_client_id}"
        client_secret          = "${var.authentication_oidc_client_secret}"
        issuer                 = "${var.authentication_oidc_issuer}"
        authorization_endpoint = "${var.authentication_oidc_authorization_endpoint}"
        token_endpoint         = "${var.authentication_oidc_token_endpoint}"
        user_info_endpoint     = "${var.authentication_oidc_user_info_endpoint}"
      }]
    }

    "NONE" = {
      type = "none"
    }
  }

  authentication_action = "${local.supported_authentication_actions[var.authentication_type]}"
}

resource "aws_lb_target_group" "default" {
  count       = "${local.target_group_enabled == "true" ? 1 : 0}"
  name        = "${module.lb_target_group_label.id}"
  port        = "${var.container_port}"
  protocol    = "${var.alb_ingress_protocol}"
  vpc_id      = "${var.vpc_id}"
  target_type = "${var.target_type}"

  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path                = "${var.alb_ingress_healthcheck_path}"
    timeout             = "${var.health_check_timeout}"
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    interval            = "${var.health_check_interval}"
    matcher             = "${var.health_check_matcher}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "unauthenticated_paths" {
  count        = "${length(var.alb_ingress_unauthenticated_paths) > 0 && length(var.alb_ingress_unauthenticated_hosts) == 0 ? var.alb_ingress_unauthenticated_listener_arns_count : 0}"
  listener_arn = "${var.alb_ingress_unauthenticated_listener_arns[count.index]}"
  priority     = "${var.alb_ingress_listener_unauthenticated_priority + count.index}"

  action = [
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "path-pattern"
    values = ["${var.alb_ingress_unauthenticated_paths}"]
  }
}

resource "aws_lb_listener_rule" "authenticated_paths" {
  count        = "${length(var.alb_ingress_authenticated_paths) > 0 && length(var.alb_ingress_authenticated_hosts) == 0 ? var.alb_ingress_authenticated_listener_arns_count : 0}"
  listener_arn = "${var.alb_ingress_authenticated_listener_arns[count.index]}"
  priority     = "${var.alb_ingress_listener_authenticated_priority + count.index}"

  action = [
    "${local.authentication_action}",
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "path-pattern"
    values = ["${var.alb_ingress_authenticated_paths}"]
  }
}

resource "aws_lb_listener_rule" "unauthenticated_hosts" {
  count        = "${length(var.alb_ingress_unauthenticated_hosts) > 0 && length(var.alb_ingress_unauthenticated_paths) == 0 ? var.alb_ingress_unauthenticated_listener_arns_count : 0}"
  listener_arn = "${var.alb_ingress_unauthenticated_listener_arns[count.index]}"
  priority     = "${var.alb_ingress_listener_unauthenticated_priority + count.index}"

  action = [
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.alb_ingress_unauthenticated_hosts}"]
  }
}

resource "aws_lb_listener_rule" "authenticated_hosts" {
  count        = "${length(var.alb_ingress_authenticated_hosts) > 0 && length(var.alb_ingress_authenticated_paths) == 0 ? var.alb_ingress_authenticated_listener_arns_count : 0}"
  listener_arn = "${var.alb_ingress_authenticated_listener_arns[count.index]}"
  priority     = "${var.alb_ingress_listener_authenticated_priority + count.index}"

  action = [
    "${local.authentication_action}",
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.alb_ingress_authenticated_hosts}"]
  }
}

resource "aws_lb_listener_rule" "unauthenticated_hosts_paths" {
  count        = "${length(var.alb_ingress_unauthenticated_paths) > 0 && length(var.alb_ingress_unauthenticated_hosts) > 0 ? var.alb_ingress_unauthenticated_listener_arns_count : 0}"
  listener_arn = "${var.alb_ingress_unauthenticated_listener_arns[count.index]}"
  priority     = "${var.alb_ingress_listener_unauthenticated_priority + count.index}"

  action = [
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.alb_ingress_unauthenticated_hosts}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${var.alb_ingress_unauthenticated_paths}"]
  }
}

resource "aws_lb_listener_rule" "authenticated_hosts_paths" {
  count        = "${length(var.alb_ingress_authenticated_paths) > 0 && length(var.alb_ingress_authenticated_hosts) > 0 ? var.alb_ingress_authenticated_listener_arns_count : 0}"
  listener_arn = "${var.alb_ingress_authenticated_listener_arns[count.index]}"
  priority     = "${var.alb_ingress_listener_authenticated_priority + count.index}"

  action = [
    "${local.authentication_action}",
    {
      type             = "forward"
      target_group_arn = "${local.target_group_arn}"
    },
  ]

  condition {
    field  = "host-header"
    values = ["${var.alb_ingress_authenticated_hosts}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${var.alb_ingress_authenticated_paths}"]
  }
}
