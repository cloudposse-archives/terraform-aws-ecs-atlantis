data "aws_kms_key" "chamber_kms_key" {
  count  = "${local.enabled && length(var.kms_key_id) == 0 ? 1 : 0}"
  key_id = "${local.kms_key_id}"
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
