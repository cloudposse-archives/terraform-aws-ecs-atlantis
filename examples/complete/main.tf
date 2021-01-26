provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.18.1"
  cidr_block = var.vpc_cidr_block

  context = module.this.context
}

module "subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "0.33.0"
  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false

  context = module.this.context
}

module "alb" {
  source                                  = "cloudposse/alb/aws"
  version                                 = "0.27.0"
  vpc_id                                  = module.vpc.vpc_id
  security_group_ids                      = [module.vpc.vpc_default_security_group_id]
  subnet_ids                              = module.subnets.public_subnet_ids
  internal                                = false
  http_enabled                            = true
  alb_access_logs_s3_bucket_force_destroy = true
  access_logs_enabled                     = true
  cross_zone_load_balancing_enabled       = true
  http2_enabled                           = true
  deletion_protection_enabled             = false

  context = module.this.context
}

resource "aws_ecs_cluster" "default" {
  name    = module.this.id
  tags    = module.this.tags
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

resource "aws_sns_topic" "sns_topic" {
  #bridgecrew:skip=BC_AWS_GENERAL_15:Skipping `Encrypt SNS Topic Data` in example/test modules
  name         = module.this.id
  display_name = "Test terraform-aws-ecs-atlantis"
  tags         = module.this.tags
}

module "kms_key" {
  source                  = "cloudposse/kms-key/aws"
  version                 = "0.9.0"
  enabled                 = var.kms_key_id == "" ? false : true
  description             = "Test terraform-aws-ecs-atlantis KMS key"
  deletion_window_in_days = 7
  enable_key_rotation     = false

  context = module.this.context
}

module "atlantis" {
  source = "../.."

  region               = var.region
  vpc_id               = module.vpc.vpc_id
  policy_arn           = var.policy_arn
  ssh_private_key_name = var.ssh_private_key_name
  ssh_public_key_name  = var.ssh_public_key_name
  kms_key_id           = var.kms_key_id == "" ? module.kms_key.key_id : var.kms_key_id
  chamber_service      = var.chamber_service

  atlantis_gh_user           = var.atlantis_gh_user
  atlantis_gh_team_whitelist = var.atlantis_gh_team_whitelist
  atlantis_gh_webhook_secret = var.atlantis_gh_webhook_secret
  atlantis_log_level         = var.atlantis_log_level
  atlantis_repo_config       = var.atlantis_repo_config
  atlantis_repo_whitelist    = var.atlantis_repo_whitelist
  atlantis_port              = var.atlantis_port
  atlantis_webhook_format    = var.atlantis_webhook_format
  atlantis_url_format        = var.atlantis_url_format

  default_backend_image = var.default_backend_image
  healthcheck_path      = var.healthcheck_path
  short_name            = var.short_name
  hostname              = var.hostname
  parent_zone_id        = var.parent_zone_id

  // Container
  container_cpu    = var.container_cpu
  container_memory = var.container_memory

  // Authentication
  authentication_type                           = var.authentication_type
  alb_ingress_listener_unauthenticated_priority = var.alb_ingress_listener_unauthenticated_priority
  alb_ingress_listener_authenticated_priority   = var.alb_ingress_listener_authenticated_priority
  alb_ingress_unauthenticated_hosts             = var.alb_ingress_unauthenticated_hosts
  alb_ingress_authenticated_hosts               = var.alb_ingress_authenticated_hosts
  alb_ingress_unauthenticated_paths             = var.alb_ingress_unauthenticated_paths
  alb_ingress_authenticated_paths               = var.alb_ingress_authenticated_paths
  authentication_cognito_user_pool_arn          = var.authentication_cognito_user_pool_arn
  authentication_cognito_user_pool_client_id    = var.authentication_cognito_user_pool_client_id
  authentication_cognito_user_pool_domain       = var.authentication_cognito_user_pool_domain
  authentication_oidc_client_id                 = var.authentication_oidc_client_id
  authentication_oidc_client_secret             = var.authentication_oidc_client_secret
  authentication_oidc_issuer                    = var.authentication_oidc_issuer
  authentication_oidc_authorization_endpoint    = var.authentication_oidc_authorization_endpoint
  authentication_oidc_token_endpoint            = var.authentication_oidc_token_endpoint
  authentication_oidc_user_info_endpoint        = var.authentication_oidc_user_info_endpoint

  // ECS
  private_subnet_ids = module.subnets.private_subnet_ids
  ecs_cluster_arn    = aws_ecs_cluster.default.arn
  ecs_cluster_name   = aws_ecs_cluster.default.name
  security_group_ids = var.security_group_ids
  desired_count      = var.desired_count
  launch_type        = var.launch_type

  // ALB
  alb_zone_id                                     = module.alb.alb_zone_id
  alb_arn_suffix                                  = module.alb.alb_arn_suffix
  alb_dns_name                                    = module.alb.alb_dns_name
  alb_security_group                              = module.alb.security_group_id
  alb_ingress_unauthenticated_listener_arns       = [module.alb.http_listener_arn]
  alb_ingress_unauthenticated_listener_arns_count = 1

  // CodePipeline
  codepipeline_enabled                 = var.codepipeline_enabled
  github_oauth_token                   = var.github_oauth_token
  github_webhooks_token                = var.github_webhooks_token
  repo_owner                           = var.repo_owner
  repo_name                            = var.repo_name
  branch                               = var.branch
  build_timeout                        = var.build_timeout
  webhook_enabled                      = var.webhook_enabled
  webhook_secret_length                = var.webhook_secret_length
  webhook_events                       = var.webhook_events
  codepipeline_s3_bucket_force_destroy = var.codepipeline_s3_bucket_force_destroy

  // Autoscaling
  autoscaling_enabled      = var.autoscaling_enabled
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity

  // Alarms
  alb_target_group_alarms_enabled                   = var.alb_target_group_alarms_enabled
  ecs_alarms_enabled                                = var.ecs_alarms_enabled
  alb_target_group_alarms_alarm_actions             = [aws_sns_topic.sns_topic.arn]
  alb_target_group_alarms_ok_actions                = [aws_sns_topic.sns_topic.arn]
  alb_target_group_alarms_insufficient_data_actions = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_cpu_utilization_high_alarm_actions     = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_cpu_utilization_high_ok_actions        = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_cpu_utilization_low_alarm_actions      = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_cpu_utilization_low_ok_actions         = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_memory_utilization_high_alarm_actions  = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_memory_utilization_high_ok_actions     = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_memory_utilization_low_alarm_actions   = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_memory_utilization_low_ok_actions      = [aws_sns_topic.sns_topic.arn]

  context = module.this.context
}
