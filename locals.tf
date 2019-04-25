locals {
  enabled = "${var.enabled == "true" ? true : false}"

  atlantis_gh_webhook_secret = "${length(var.atlantis_gh_webhook_secret) > 0 ? var.atlantis_gh_webhook_secret : join("", random_string.atlantis_gh_webhook_secret.*.result)}"
  atlantis_url               = "${format(var.atlantis_webhook_format, local.hostname)}"

  attributes = "${concat(list(var.short_name), var.attributes)}"

  default_hostname = "${join("", aws_route53_record.default.*.fqdn)}"
  hostname         = "${length(var.hostname) > 0 ? var.hostname : local.default_hostname}"

  github_oauth_token          = "${length(join("", data.aws_ssm_parameter.atlantis_gh_token.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_gh_token.*.value) : var.github_oauth_token}"
  github_oauth_token_ssm_name = "${length(var.github_oauth_token_ssm_name) > 0 ? var.github_oauth_token_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_gh_token")}"

  kms_key_id = "${length(var.kms_key_id) > 0 ? var.kms_key_id : format("alias/%s-%s-chamber", var.namespace, var.stage)}"

  cpu_utilization_high_alarm_actions    = "${var.autoscaling_enabled == "true" && var.autoscaling_dimension == "cpu" ? module.autoscaling.scale_up_policy_arn : ""}"
  cpu_utilization_low_alarm_actions     = "${var.autoscaling_enabled == "true" && var.autoscaling_dimension == "cpu" ? module.autoscaling.scale_down_policy_arn : ""}"
  memory_utilization_high_alarm_actions = "${var.autoscaling_enabled == "true" && var.autoscaling_dimension == "memory" ? module.autoscaling.scale_up_policy_arn : ""}"
  memory_utilization_low_alarm_actions  = "${var.autoscaling_enabled == "true" && var.autoscaling_dimension == "memory" ? module.autoscaling.scale_down_policy_arn : ""}"

  kms_key_id = "${length(var.kms_key_id) > 0 ? var.kms_key_id : format("alias/%s-%s-chamber", var.namespace, var.stage)}"

  atlantis_cognito_user_pool_arn          = "${length(join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_arn.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_arn.*.value) : var.authentication_cognito_user_pool_arn}"
  atlantis_cognito_user_pool_arn_ssm_name = "${length(var.authentication_cognito_user_pool_arn_ssm_name) > 0 ? var.authentication_cognito_user_pool_arn_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_cognito_user_pool_arn")}"

  atlantis_cognito_user_pool_client_id          = "${length(join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_client_id.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_client_id.*.value) : var.authentication_cognito_user_pool_client_id}"
  atlantis_cognito_user_pool_client_id_ssm_name = "${length(var.authentication_cognito_user_pool_client_id_ssm_name) > 0 ? var.authentication_cognito_user_pool_client_id_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_cognito_user_pool_client_id")}"

  atlantis_cognito_user_pool_domain          = "${length(join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_domain.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_cognito_user_pool_domain.*.value) : var.authentication_cognito_user_pool_domain}"
  atlantis_cognito_user_pool_domain_ssm_name = "${length(var.authentication_cognito_user_pool_domain_ssm_name) > 0 ? var.authentication_cognito_user_pool_domain_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_cognito_user_pool_domain")}"

  atlantis_oidc_client_id          = "${length(join("", data.aws_ssm_parameter.atlantis_oidc_client_id.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_oidc_client_id.*.value) : var.authentication_oidc_client_id}"
  atlantis_oidc_client_id_ssm_name = "${length(var.authentication_oidc_client_id_ssm_name) > 0 ? var.authentication_oidc_client_id_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_oidc_client_id")}"

  atlantis_oidc_client_secret          = "${length(join("", data.aws_ssm_parameter.atlantis_oidc_client_secret.*.value)) > 0 ? join("", data.aws_ssm_parameter.atlantis_oidc_client_secret.*.value) : var.authentication_oidc_client_secret}"
  atlantis_oidc_client_secret_ssm_name = "${length(var.authentication_oidc_client_secret_ssm_name) > 0 ? var.authentication_oidc_client_secret_ssm_name : format(var.chamber_format, var.chamber_service, "atlantis_oidc_client_secret")}"
}
