module "webhooks" {
  source              = "git::https://github.com/cloudposse/terraform-github-repository-webhooks.git?ref=tags/0.1.1"
  github_token        = "${local.github_oauth_token}"
  webhook_secret      = "${local.atlantis_gh_webhook_secret}"
  webhook_url         = "${local.atlantis_url}"
  enabled             = "${var.enabled}"
  github_organization = "${var.repo_owner}"
  github_repositories = ["${var.repo_name}"]
  events              = ["${var.webhook_events}"]
}

resource "random_string" "atlantis_gh_webhook_secret" {
  count   = "${local.enabled ? 1 : 0}"
  length  = "${var.webhook_secret_length}"
  special = true
}
