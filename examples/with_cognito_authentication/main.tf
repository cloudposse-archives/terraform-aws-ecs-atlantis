provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.18.1"
  cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "0.33.0"
  availability_zones   = local.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false

  context = module.this.context
}

module "alb" {
  source                                  = "cloudposse/alb/aws"
  version                                 = "0.24.0"
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

# ECS Cluster (needed even if using FARGATE launch type)
resource "aws_ecs_cluster" "default" {
  name    = module.this.id
  tags    = module.this.tags
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

module "atlantis" {
  source  = "../.."
  enabled = true

  atlantis_gh_team_whitelist = var.atlantis_gh_team_whitelist
  atlantis_gh_user           = var.atlantis_gh_user
  atlantis_repo_whitelist    = [var.atlantis_repo_whitelist]

  alb_arn_suffix     = module.alb.alb_arn_suffix
  alb_dns_name       = module.alb.alb_dns_name
  alb_name           = module.alb.alb_name
  alb_zone_id        = module.alb.alb_zone_id
  alb_security_group = module.alb.security_group_id

  container_cpu    = var.atlantis_container_cpu
  container_memory = var.atlantis_container_memory

  branch             = var.atlantis_branch
  parent_zone_id     = var.parent_zone_id
  ecs_cluster_arn    = aws_ecs_cluster.default.arn
  ecs_cluster_name   = aws_ecs_cluster.default.name
  repo_name          = var.atlantis_repo_name
  repo_owner         = var.atlantis_repo_owner
  private_subnet_ids = [module.subnets.private_subnet_ids]
  security_group_ids = [module.vpc.vpc_default_security_group_id]
  vpc_id             = module.vpc.vpc_id

  alb_ingress_authenticated_listener_arns       = [module.alb.https_listener_arn]
  alb_ingress_authenticated_listener_arns_count = 1

  alb_ingress_unauthenticated_listener_arns       = [module.alb.listener_arns]
  alb_ingress_unauthenticated_listener_arns_count = 2

  # Unauthenticated paths (with higher priority than the authenticated paths)
  alb_ingress_unauthenticated_paths             = ["/events"]
  alb_ingress_listener_unauthenticated_priority = 50

  # Authenticated paths
  alb_ingress_authenticated_paths             = ["/*"]
  alb_ingress_listener_authenticated_priority = 100

  authentication_type                        = "COGNITO"
  authentication_cognito_user_pool_arn       = var.cognito_user_pool_arn
  authentication_cognito_user_pool_client_id = var.cognito_user_pool_client_id
  authentication_cognito_user_pool_domain    = var.cognito_user_pool_domain

  context = module.this.context
}
