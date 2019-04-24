module "container_definition" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.9.1"
  container_name               = "${module.default_label.id}"
  container_image              = "${var.container_image}"
  container_memory             = "${var.container_memory}"
  container_memory_reservation = "${var.container_memory_reservation}"
  container_cpu                = "${var.container_cpu}"
  healthcheck                  = "${var.healthcheck}"
  environment                  = "${var.environment}"
  port_mappings                = "${var.port_mappings}"

  log_options = {
    "awslogs-region"        = "${var.aws_logs_region}"
    "awslogs-group"         = "${aws_cloudwatch_log_group.app.name}"
    "awslogs-stream-prefix" = "${var.name}"
  }
}
