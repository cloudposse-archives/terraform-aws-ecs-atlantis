data "aws_kms_key" "chamber_kms_key" {
  count  = "${local.enabled && length(var.kms_key_id) == 0 ? 1 : 0}"
  key_id = "${local.kms_key_id}"
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
  description = "URL to reach Atlantis e.g. for webhooks"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_atlantis_url")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "String"
  value       = "${local.atlantis_url}"
}

resource "aws_ssm_parameter" "atlantis_allow_repo_config" {
  count       = "${local.enabled ? 1 : 0}"
  description = "allow Atlantis to use atlantis.yaml"
  name        = "${format(var.chamber_format, var.chamber_service, "atlantis_allow_repo_config")}"
  overwrite   = "${var.overwrite_ssm_parameter}"
  type        = "String"
  value       = "${var.atlantis_allow_repo_config}"
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
  value       = "${module.ecs_alb_service_task.task_role_arn}"
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
