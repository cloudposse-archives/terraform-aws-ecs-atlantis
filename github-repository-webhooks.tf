module "webhooks" {
  source              = "git::https://github.com/cloudposse/terraform-github-repository-webhooks.git?ref=tags/0.1.1"
  enabled             = "${var.enabled}"
  github_token        = "${local.github_oauth_token}"
  webhook_secret      = "${local.atlantis_gh_webhook_secret}"
  webhook_url         = "${local.atlantis_url}"
  github_organization = "${var.repo_owner}"
  github_repositories = ["${var.repo_name}"]
  events              = ["${var.webhook_events}"]
}

data "aws_ssm_parameter" "atlantis_gh_token" {
  count = "${local.enabled && length(var.github_oauth_token) == 0 ? 1 : 0}"
  name  = "${local.github_oauth_token_ssm_name}"
}

resource "random_string" "atlantis_gh_webhook_secret" {
  count   = "${local.enabled ? 1 : 0}"
  length  = "${var.webhook_secret_length}"
  special = true
}
