# Pin the `aws` provider
# https://www.terraform.io/docs/configuration/providers.html
# Any non-beta version >= 2.12.0 and < 2.13.0, e.g. 2.12.X
provider "aws" {
  version = "~> 2.12.0"
}

# Terraform
#--------------------------------------------------------------
terraform {
  required_version = "~> 0.11.0"
}

# Data
#--------------------------------------------------------------
data "aws_ssm_parameter" "atlantis_gh_token" {
  count = "${local.enabled && length(var.github_oauth_token) == 0 ? 1 : 0}"
  name  = "${local.github_oauth_token_ssm_name}"
}

data "aws_ssm_parameter" "github_webhooks_token" {
  count = "${local.enabled && length(var.github_webhooks_token) == 0 ? 1 : 0}"
  name  = "${local.github_webhooks_token_ssm_name}"
}

data "aws_kms_key" "chamber_kms_key" {
  count  = "${local.enabled && length(var.kms_key_id) == 0 ? 1 : 0}"
  key_id = "${local.kms_key_id}"
}

# Locals
#--------------------------------------------------------------
locals {
  enabled                    = "${var.enabled == "true" ? true : false}"
  atlantis_gh_webhook_secret = "${length(var.atlantis_gh_webhook_secret) > 0 ? var.atlantis_gh_webhook_secret : join("", random_string.atlantis_gh_webhook_secret.*.result)}"
  atlantis_webhook_url       = "${format(var.atlantis_webhook_format, local.hostname)}"
  atlantis_url               = "${format(var.atlantis_url_format, local.hostname)}"
  attributes                 = "${concat(list(var.short_name), var.attributes)}"
  default_hostname           = "${join("", aws_route53_record.default.*.fqdn)}"
  hostname                   = "${length(var.hostname) > 0 ? var.hostname : local.default_hostname}"
  kms_key_id                 = "${length(var.kms_key_id) > 0 ? var.kms_key_id : format("alias/%s-%s-chamber", var.namespace, var.stage)}"
}

# GitHub tokens
locals {
  github_oauth_token          = "${length(join("", data.aws_ssm_parameter.atlantis_gh_token.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_gh_token.*.value) : var.github_oauth_token}"
  github_oauth_token_ssm_name = "${length(var.github_oauth_token_ssm_name) > 0 ? var.github_oauth_token_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_gh_token")}"

  github_webhooks_token          = "${length(join("", data.aws_ssm_parameter.github_webhooks_token.*.value)) > 0 ? join("", data.aws_ssm_parameter.github_webhooks_token.*.value) : var.github_webhooks_token}"
  github_webhooks_token_ssm_name = "${length(var.github_webhooks_token_ssm_name) > 0 ? var.github_webhooks_token_ssm_name : format(var.chamber_format, var.chamber_service, "github_webhooks_token")}"
}

# Modules
#--------------------------------------------------------------
module "ssh_key_pair" {
  source               = "git::https://github.com/cloudposse/terraform-aws-ssm-tls-ssh-key-pair.git?ref=tags/0.2.0"
  enabled              = "${local.enabled}"
  namespace            = "${var.namespace}"
  stage                = "${var.stage}"
  name                 = "${var.name}"
  attributes           = "${local.attributes}"
  ssh_private_key_name = "${var.ssh_private_key_name}"
  ssh_public_key_name  = "${var.ssh_public_key_name}"
  ssm_path_prefix      = "${var.chamber_service}"
}

module "webhooks" {
  source              = "git::https://github.com/cloudposse/terraform-github-repository-webhooks.git?ref=tags/0.4.0"
  github_token        = "${local.github_webhooks_token}"
  webhook_secret      = "${local.atlantis_gh_webhook_secret}"
  webhook_url         = "${local.atlantis_webhook_url}"
  enabled             = "${local.enabled}"
  github_organization = "${var.repo_owner}"
  github_repositories = ["${var.repo_name}"]
  events              = ["${var.webhook_events}"]
}

module "web_app" {
  source     = "git::https://github.com/cloudposse/terraform-aws-ecs-web-app.git?ref=0.11/extract-provider"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  attributes = "${local.attributes}"

  vpc_id = "${var.vpc_id}"

  environment = [
    {
      name  = "ATLANTIS_ENABLED"
      value = "${local.enabled}"
    },
  ]

  github_webhook_events       = ["release"]
  webhook_filter_json_path    = "$.action"
  webhook_filter_match_equals = "published"

  container_image  = "${var.default_backend_image}"
  container_cpu    = "${var.container_cpu}"
  container_memory = "${var.container_memory}"

  codepipeline_enabled = "${local.enabled}"

  container_port = "${var.atlantis_port}"

  port_mappings = [{
    "containerPort" = "${var.atlantis_port}"
    "hostPort"      = "${var.atlantis_port}"
    "protocol"      = "tcp"
  }]

  desired_count = "${var.desired_count}"

  autoscaling_enabled               = "${local.enabled}"
  autoscaling_dimension             = "cpu"
  autoscaling_min_capacity          = "${var.autoscaling_min_capacity}"
  autoscaling_max_capacity          = "${var.autoscaling_max_capacity}"
  autoscaling_scale_up_adjustment   = "1"
  autoscaling_scale_up_cooldown     = "60"
  autoscaling_scale_down_adjustment = "-1"
  autoscaling_scale_down_cooldown   = "300"

  aws_logs_region        = "${var.region}"
  ecs_alarms_enabled     = "${local.enabled}"
  ecs_cluster_arn        = "${var.ecs_cluster_arn}"
  ecs_cluster_name       = "${var.ecs_cluster_name}"
  ecs_security_group_ids = ["${var.security_group_ids}"]
  ecs_private_subnet_ids = ["${var.private_subnet_ids}"]

  alb_ingress_healthcheck_path = "${var.healthcheck_path}"

  github_oauth_token    = "${local.github_oauth_token}"
  repo_owner            = "${var.repo_owner}"
  repo_name             = "${var.repo_name}"
  branch                = "${var.branch}"
  build_timeout         = "${var.build_timeout}"
  badge_enabled         = "false"

  codepipeline_s3_bucket_force_destroy = "${var.codepipeline_s3_bucket_force_destroy}"

  alb_target_group_alarms_enabled                 = "${local.enabled}"
  alb_target_group_alarms_3xx_threshold           = "25"
  alb_target_group_alarms_4xx_threshold           = "25"
  alb_target_group_alarms_5xx_threshold           = "25"
  alb_target_group_alarms_response_time_threshold = "0.5"
  alb_target_group_alarms_period                  = "300"
  alb_target_group_alarms_evaluation_periods      = "1"
  alb_name                                        = "${var.alb_name}"
  alb_arn_suffix                                  = "${var.alb_arn_suffix}"
  alb_security_group                              = "${var.alb_security_group}"

  alb_target_group_alarms_alarm_actions             = ["${var.alb_target_group_alarms_alarm_actions}"]
  alb_target_group_alarms_ok_actions                = ["${var.alb_target_group_alarms_ok_actions}"]
  alb_target_group_alarms_insufficient_data_actions = ["${var.alb_target_group_alarms_insufficient_data_actions}"]

  alb_ingress_authenticated_paths   = ["${var.alb_ingress_authenticated_paths}"]
  alb_ingress_unauthenticated_paths = ["${var.alb_ingress_unauthenticated_paths}"]
  alb_ingress_authenticated_hosts   = ["${var.alb_ingress_authenticated_hosts}"]
  alb_ingress_unauthenticated_hosts = ["${var.alb_ingress_unauthenticated_hosts}"]

  alb_ingress_listener_authenticated_priority   = "${var.alb_ingress_listener_authenticated_priority}"
  alb_ingress_listener_unauthenticated_priority = "${var.alb_ingress_listener_unauthenticated_priority}"

  alb_ingress_unauthenticated_listener_arns       = "${var.alb_ingress_unauthenticated_listener_arns}"
  alb_ingress_unauthenticated_listener_arns_count = "${var.alb_ingress_unauthenticated_listener_arns_count}"
  alb_ingress_authenticated_listener_arns         = "${var.alb_ingress_authenticated_listener_arns}"
  alb_ingress_authenticated_listener_arns_count   = "${var.alb_ingress_authenticated_listener_arns_count}"

  authentication_type                        = "${var.authentication_type}"
  authentication_cognito_user_pool_arn       = "${local.authentication_cognito_user_pool_arn}"
  authentication_cognito_user_pool_client_id = "${local.authentication_cognito_user_pool_client_id}"
  authentication_cognito_user_pool_domain    = "${local.authentication_cognito_user_pool_domain}"
  authentication_oidc_client_id              = "${local.authentication_oidc_client_id}"
  authentication_oidc_client_secret          = "${local.authentication_oidc_client_secret}"
  authentication_oidc_issuer                 = "${var.authentication_oidc_issuer}"
  authentication_oidc_authorization_endpoint = "${var.authentication_oidc_authorization_endpoint}"
  authentication_oidc_token_endpoint         = "${var.authentication_oidc_token_endpoint}"
  authentication_oidc_user_info_endpoint     = "${var.authentication_oidc_user_info_endpoint}"
}

# Resources
#--------------------------------------------------------------

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

resource "random_string" "atlantis_gh_webhook_secret" {
  count   = "${local.enabled ? 1 : 0}"
  length  = "${var.webhook_secret_length}"
  special = true
}

resource "aws_ssm_parameter" "atlantis_port" {
  count       = "${local.enabled ? 1 : 0}"
  description = "Atlantis server port"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_port")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "String"
  value       = "${var.atlantis_port}"
}

resource "aws_ssm_parameter" "atlantis_atlantis_url" {
  count       = "${local.enabled ? 1 : 0}"
  description = "Atlantis URL"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_atlantis_url")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "String"
  value       = "${local.atlantis_url}"
}

resource "aws_ssm_parameter" "atlantis_gh_user" {
  count       = "${local.enabled ? 1 : 0}"
  description = "Atlantis GitHub user"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_gh_user")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "String"
  value       = "${var.atlantis_gh_user}"
}

resource "aws_ssm_parameter" "atlantis_gh_team_whitelist" {
  count       = "${local.enabled ? 1 : 0}"
  description = "Atlantis GitHub team whitelist"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_gh_team_whitelist")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "String"
  value       = "${var.atlantis_gh_team_whitelist}"
}

resource "aws_ssm_parameter" "atlantis_gh_webhook_secret" {
  count       = "${local.enabled ? 1 : 0}"
  description = "Atlantis GitHub webhook secret"
  key_id      = "${join("", data.aws_kms_key.chamber_kms_key.*.id)}"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_gh_webhook_secret")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "SecureString"
  value       = "${local.atlantis_gh_webhook_secret}"
}

resource "aws_ssm_parameter" "atlantis_iam_role_arn" {
  count       = "${local.enabled ? 1 : 0}"
  description = "Atlantis IAM role ARN"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_iam_role_arn")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "String"
  value       = "${module.web_app.task_role_arn}"
}

resource "aws_ssm_parameter" "atlantis_log_level" {
  count       = "${local.enabled ? 1 : 0}"
  description = "Atlantis log level"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_log_level")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "String"
  value       = "${var.atlantis_log_level}"
}

resource "aws_ssm_parameter" "atlantis_repo_config" {
  count       = "${local.enabled ? 1 : 0}"
  description = "Path to atlantis config file"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_repo_config")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "String"
  value       = "${var.atlantis_repo_config}"
}

resource "aws_ssm_parameter" "atlantis_repo_whitelist" {
  count       = "${local.enabled ? 1 : 0}"
  description = "Whitelist of repositories Atlantis will accept webhooks from"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_repo_whitelist")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "String"
  value       = "${join(",", var.atlantis_repo_whitelist)}"
}

resource "aws_ssm_parameter" "atlantis_wake_word" {
  count       = "${local.enabled ? 1 : 0}"
  description = "Wake world for Atlantis"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_wake_word")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "String"
  value       = "${var.atlantis_wake_word}"
}

resource "aws_ssm_parameter" "atlantis_gh_token" {
  count       = "${local.enabled ? 1 : 0}"
  description = "Atlantis GitHub OAuth token"
  key_id      = "${join("", data.aws_kms_key.chamber_kms_key.*.id)}"
  name        = "${local.github_oauth_token_ssm_name}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "SecureString"
  value       = "${local.github_oauth_token}"
}

resource "aws_ssm_parameter" "github_webhooks_token" {
  count       = "${local.enabled ? 1 : 0}"
  description = "GitHub OAuth token with permission to create webhooks"
  key_id      = "${join("", data.aws_kms_key.chamber_kms_key.*.id)}"
  name        = "${local.github_webhooks_token_ssm_name}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "SecureString"
  value       = "${local.github_webhooks_token}"
}

resource "aws_security_group_rule" "egress_http" {
  count             = "${local.enabled ? 1 : 0}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${module.web_app.service_security_group_id}"
  to_port           = 80
  type              = "egress"
}

resource "aws_security_group_rule" "egress_https" {
  count             = "${local.enabled ? 1 : 0}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${module.web_app.service_security_group_id}"
  to_port           = 443
  type              = "egress"
}

resource "aws_security_group_rule" "egress_udp_dns" {
  count             = "${local.enabled ? 1 : 0}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 53
  protocol          = "udp"
  security_group_id = "${module.web_app.service_security_group_id}"
  to_port           = 53
  type              = "egress"
}

resource "aws_security_group_rule" "egress_tcp_dns" {
  count             = "${local.enabled ? 1 : 0}"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 53
  protocol          = "tcp"
  security_group_id = "${module.web_app.service_security_group_id}"
  to_port           = 53
  type              = "egress"
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = "${local.enabled ? 1 : 0}"
  role       = "${module.web_app.task_role_name}"
  policy_arn = "${var.policy_arn}"

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  authentication_cognito_user_pool_arn          = "${length(join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_arn.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_arn.*.value) : var.authentication_cognito_user_pool_arn}"
  authentication_cognito_user_pool_arn_ssm_name = "${length(var.authentication_cognito_user_pool_arn_ssm_name) > 0 ? var.authentication_cognito_user_pool_arn_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_cognito_user_pool_arn")}"

  authentication_cognito_user_pool_client_id          = "${length(join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_client_id.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_client_id.*.value) : var.authentication_cognito_user_pool_client_id}"
  authentication_cognito_user_pool_client_id_ssm_name = "${length(var.authentication_cognito_user_pool_client_id_ssm_name) > 0 ? var.authentication_cognito_user_pool_client_id_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_cognito_user_pool_client_id")}"

  authentication_cognito_user_pool_domain          = "${length(join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_domain.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_domain.*.value) : var.authentication_cognito_user_pool_domain}"
  authentication_cognito_user_pool_domain_ssm_name = "${length(var.authentication_cognito_user_pool_domain_ssm_name) > 0 ? var.authentication_cognito_user_pool_domain_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_cognito_user_pool_domain")}"

  authentication_oidc_client_id          = "${length(join("", data.aws_ssm_parameter.atlantis_oidc_client_id.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_oidc_client_id.*.value) : var.authentication_oidc_client_id}"
  authentication_oidc_client_id_ssm_name = "${length(var.authentication_oidc_client_id_ssm_name) > 0 ? var.authentication_oidc_client_id_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_oidc_client_id")}"

  authentication_oidc_client_secret          = "${length(join("", data.aws_ssm_parameter.atlantis_oidc_client_secret.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_oidc_client_secret.*.value) : var.authentication_oidc_client_secret}"
  authentication_oidc_client_secret_ssm_name = "${length(var.authentication_oidc_client_secret_ssm_name) > 0 ? var.authentication_oidc_client_secret_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_oidc_client_secret")}"
}

data "aws_ssm_parameter" "atlantis_cognito_user_pool_arn" {
  count = "${local.enabled && var.authentication_type == "COGNITO" && length(var.authentication_cognito_user_pool_arn) == 0 ? 1 : 0}"
  name  = "${local.authentication_cognito_user_pool_arn_ssm_name}"
}

data "aws_ssm_parameter" "atlantis_cognito_user_pool_client_id" {
  count = "${local.enabled && var.authentication_type == "COGNITO" && length(var.authentication_cognito_user_pool_client_id) == 0 ? 1 : 0}"
  name  = "${local.authentication_cognito_user_pool_client_id_ssm_name}"
}

data "aws_ssm_parameter" "atlantis_cognito_user_pool_domain" {
  count = "${local.enabled && var.authentication_type == "COGNITO" && length(var.authentication_cognito_user_pool_domain) == 0 ? 1 : 0}"
  name  = "${local.authentication_cognito_user_pool_domain_ssm_name}"
}

data "aws_ssm_parameter" "atlantis_oidc_client_id" {
  count = "${local.enabled && var.authentication_type == "OIDC" && length(var.authentication_oidc_client_id) == 0 ? 1 : 0}"
  name  = "${local.authentication_oidc_client_id_ssm_name}"
}

data "aws_ssm_parameter" "atlantis_oidc_client_secret" {
  count = "${local.enabled && var.authentication_type == "OIDC" && length(var.authentication_oidc_client_secret) == 0 ? 1 : 0}"
  name  = "${local.authentication_oidc_client_secret_ssm_name}"
}

resource "aws_ssm_parameter" "atlantis_cognito_user_pool_arn" {
  count       = "${local.enabled && var.authentication_type == "COGNITO" ? 1 : 0}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "SecureString"
  description = "Atlantis Cognito User Pool ARN"
  key_id      = "${local.kms_key_id}"
  name        = "${local.authentication_cognito_user_pool_arn_ssm_name}"
  value       = "${local.authentication_cognito_user_pool_arn}"
}

resource "aws_ssm_parameter" "atlantis_cognito_user_pool_client_id" {
  count       = "${local.enabled && var.authentication_type == "COGNITO" ? 1 : 0}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "SecureString"
  description = "Atlantis Cognito User Pool Client ID"
  key_id      = "${local.kms_key_id}"
  name        = "${local.authentication_cognito_user_pool_client_id_ssm_name}"
  value       = "${local.authentication_cognito_user_pool_client_id}"
}

resource "aws_ssm_parameter" "atlantis_cognito_user_pool_domain" {
  count       = "${local.enabled && var.authentication_type == "COGNITO" ? 1 : 0}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "SecureString"
  description = "Atlantis Cognito User Pool Domain"
  key_id      = "${local.kms_key_id}"
  name        = "${local.authentication_cognito_user_pool_domain_ssm_name}"
  value       = "${local.authentication_cognito_user_pool_domain}"
}

resource "aws_ssm_parameter" "atlantis_oidc_client_id" {
  count       = "${local.enabled && var.authentication_type == "OIDC" ? 1 : 0}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "SecureString"
  description = "Atlantis OIDC Client ID"
  key_id      = "${local.kms_key_id}"
  name        = "${local.authentication_oidc_client_id_ssm_name}"
  value       = "${local.authentication_oidc_client_id}"
}

resource "aws_ssm_parameter" "atlantis_oidc_client_secret" {
  count       = "${local.enabled && var.authentication_type == "OIDC" ? 1 : 0}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "SecureString"
  description = "Atlantis OIDC Client Secret"
  key_id      = "${local.kms_key_id}"
  name        = "${local.authentication_oidc_client_secret_ssm_name}"
  value       = "${local.authentication_oidc_client_secret}"
}
