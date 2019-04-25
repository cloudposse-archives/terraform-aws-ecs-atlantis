module "ecs_alb_service_task" {
  source                            = "git::https://github.com/cloudposse/terraform-aws-ecs-alb-service-task.git?ref=tags/0.10.0"
  name                              = "${var.name}"
  namespace                         = "${var.namespace}"
  stage                             = "${var.stage}"
  attributes                        = "${var.attributes}"
  alb_target_group_arn              = "${data.aws_lb_target_group.default.arn}"
  container_definition_json         = "${module.container_definition.json}"
  container_name                    = "${module.default_label.id}"
  desired_count                     = "${var.desired_count}"
  health_check_grace_period_seconds = "${var.health_check_grace_period_seconds}"
  task_cpu                          = "${var.container_cpu}"
  task_memory                       = "${var.container_memory}"
  ecs_cluster_arn                   = "${var.ecs_cluster_arn}"
  launch_type                       = "${var.launch_type}"
  vpc_id                            = "${var.vpc_id}"
  security_group_ids                = ["${var.ecs_security_group_ids}"]
  private_subnet_ids                = ["${var.ecs_private_subnet_ids}"]
  container_port                    = "${var.container_port}"
}

resource "aws_security_group_rule" "egress_http" {
  count             = "${local.enabled ? 1 : 0}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${module.ecs_alb_service_task.service_security_group_id}"
  to_port           = 80
  type              = "egress"
}

resource "aws_security_group_rule" "egress_https" {
  count             = "${local.enabled ? 1 : 0}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${module.ecs_alb_service_task.service_security_group_id}"
  to_port           = 443
  type              = "egress"
}

resource "aws_security_group_rule" "egress_udp_dns" {
  count             = "${local.enabled ? 1 : 0}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 53
  protocol          = "udp"
  security_group_id = "${module.ecs_alb_service_task.service_security_group_id}"
  to_port           = 53
  type              = "egress"
}

resource "aws_security_group_rule" "egress_tcp_dns" {
  count             = "${local.enabled ? 1 : 0}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 53
  protocol          = "tcp"
  security_group_id = "${module.ecs_alb_service_task.service_security_group_id}"
  to_port           = 53
  type              = "egress"
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = "${local.enabled ? 1 : 0}"
  role       = "${module.ecs_alb_service_task.task_role_name}"
  policy_arn = "${var.policy_arn}"

  lifecycle {
    create_before_destroy = true
  }
}
