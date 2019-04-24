data "aws_ssm_parameter" "atlantis_gh_token" {
  count = "${local.enabled && length(var.github_oauth_token) == 0 ? 1 : 0}"
  name  = "${local.github_oauth_token_ssm_name}"
}

data "aws_kms_key" "chamber_kms_key" {
  count  = "${local.enabled && length(var.kms_key_id) == 0 ? 1 : 0}"
  key_id = "${local.kms_key_id}"
}
