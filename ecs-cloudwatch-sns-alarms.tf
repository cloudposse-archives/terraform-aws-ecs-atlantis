module "ecs_alarms" {
  source  = "git::https://github.com/cloudposse/terraform-aws-ecs-cloudwatch-sns-alarms.git?ref=tags/0.4.0"
  enabled = "${local.enabled && var.ecs_alarms_enabled == "true" ? "true" : "false"}"

  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"

  cluster_name = "${var.ecs_cluster_name}"
  service_name = "${module.ecs_alb_service_task.service_name}"

  cpu_utilization_high_threshold          = "${var.ecs_alarms_cpu_utilization_high_threshold}"
  cpu_utilization_high_evaluation_periods = "${var.ecs_alarms_cpu_utilization_high_evaluation_periods}"
  cpu_utilization_high_period             = "${var.ecs_alarms_cpu_utilization_high_period}"
  cpu_utilization_high_alarm_actions      = "${compact(concat(var.ecs_alarms_cpu_utilization_high_alarm_actions, list(local.cpu_utilization_high_alarm_actions)))}"
  cpu_utilization_high_ok_actions         = "${var.ecs_alarms_cpu_utilization_high_ok_actions}"

  cpu_utilization_low_threshold          = "${var.ecs_alarms_cpu_utilization_low_threshold}"
  cpu_utilization_low_evaluation_periods = "${var.ecs_alarms_cpu_utilization_low_evaluation_periods}"
  cpu_utilization_low_period             = "${var.ecs_alarms_cpu_utilization_low_period}"
  cpu_utilization_low_alarm_actions      = "${compact(concat(var.ecs_alarms_cpu_utilization_low_alarm_actions, list(local.cpu_utilization_low_alarm_actions)))}"
  cpu_utilization_low_ok_actions         = "${var.ecs_alarms_cpu_utilization_low_ok_actions}"

  memory_utilization_high_threshold          = "${var.ecs_alarms_memory_utilization_high_threshold}"
  memory_utilization_high_evaluation_periods = "${var.ecs_alarms_memory_utilization_high_evaluation_periods}"
  memory_utilization_high_period             = "${var.ecs_alarms_memory_utilization_high_period}"
  memory_utilization_high_alarm_actions      = "${compact(concat(var.ecs_alarms_memory_utilization_high_alarm_actions, list(local.memory_utilization_high_alarm_actions)))}"
  memory_utilization_high_ok_actions         = "${var.ecs_alarms_memory_utilization_high_ok_actions}"

  memory_utilization_low_threshold          = "${var.ecs_alarms_memory_utilization_low_threshold}"
  memory_utilization_low_evaluation_periods = "${var.ecs_alarms_memory_utilization_low_evaluation_periods}"
  memory_utilization_low_period             = "${var.ecs_alarms_memory_utilization_low_period}"
  memory_utilization_low_alarm_actions      = "${compact(concat(var.ecs_alarms_memory_utilization_low_alarm_actions, list(local.memory_utilization_low_alarm_actions)))}"
  memory_utilization_low_ok_actions         = "${var.ecs_alarms_memory_utilization_low_ok_actions}"
}
