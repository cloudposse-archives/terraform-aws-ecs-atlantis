module "ecs_codepipeline" {
  enabled               = "${var.codepipeline_enabled}"
  source                = "git::https://github.com/cloudposse/terraform-aws-ecs-codepipeline.git?ref=tags/0.6.1"
  name                  = "${var.name}"
  namespace             = "${var.namespace}"
  stage                 = "${var.stage}"
  attributes            = "${var.attributes}"
  github_oauth_token    = "${var.github_oauth_token}"
  github_webhook_events = "${var.github_webhook_events}"
  repo_owner            = "${var.repo_owner}"
  repo_name             = "${var.repo_name}"
  branch                = "${var.branch}"
  badge_enabled         = "${var.badge_enabled}"
  build_image           = "${var.build_image}"
  build_timeout         = "${var.build_timeout}"
  buildspec             = "${var.buildspec}"
  image_repo_name       = "${module.ecr.repository_name}"
  service_name          = "${module.ecs_alb_service_task.service_name}"
  ecs_cluster_name      = "${var.ecs_cluster_name}"
  privileged_mode       = "true"
  poll_source_changes   = "${var.poll_source_changes}"

  webhook_enabled             = "${var.webhook_enabled}"
  webhook_target_action       = "${var.webhook_target_action}"
  webhook_authentication      = "${var.webhook_authentication}"
  webhook_filter_json_path    = "${var.webhook_filter_json_path}"
  webhook_filter_match_equals = "${var.webhook_filter_match_equals}"

  environment_variables = [{
    "name"  = "CONTAINER_NAME"
    "value" = "${module.default_label.id}"
  }]
}
