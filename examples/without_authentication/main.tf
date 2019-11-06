provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.1"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  delimiter  = var.delimiter
  attributes = var.attributes
  cidr_block = "172.16.0.0/16"
  tags       = var.tags
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.16.1"
  availability_zones   = local.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  attributes           = var.attributes
  delimiter            = var.delimiter
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
  tags                 = var.tags
}

module "alb" {
  source                                  = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=tags/0.7.0"
  namespace                               = var.namespace
  stage                                   = var.stage
  name                                    = var.name
  attributes                              = var.attributes
  delimiter                               = var.delimiter
  vpc_id                                  = module.vpc.vpc_id
  security_group_ids                      = [module.vpc.vpc_default_security_group_id]
  subnet_ids                              = module.subnets.public_subnet_ids
  internal                                = false
  http_enabled                            = true
  alb_access_logs_s3_bucket_force_destroy = true
  access_logs_enabled                     = true
  access_logs_region                      = var.region
  cross_zone_load_balancing_enabled       = true
  http2_enabled                           = true
  deletion_protection_enabled             = false
  tags                                    = var.tags
}

module "ecs_cluster_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
  attributes = var.attributes
  delimiter  = var.delimiter
}

# ECS Cluster (needed even if using FARGATE launch type)
resource "aws_ecs_cluster" "default" {
  name = module.ecs_cluster_label.id
}

module "atlantis" {
  source    = "../.."
  enabled   = true
  name      = var.name
  namespace = var.namespace
  region    = var.region
  stage     = var.stage

  atlantis_gh_team_whitelist = var.atlantis_gh_team_whitelist
  atlantis_gh_user           = var.atlantis_gh_user
  atlantis_repo_whitelist    = var.atlantis_repo_whitelist

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
  private_subnet_ids = module.subnets.private_subnet_ids
  security_group_ids = [module.vpc.vpc_default_security_group_id]
  vpc_id             = module.vpc.vpc_id

  # Without authentication, both HTTP and HTTPS endpoints are supported
  alb_ingress_unauthenticated_listener_arns       = [module.alb.listener_arns]
  alb_ingress_unauthenticated_listener_arns_count = 2

  # All paths are unauthenticated
  alb_ingress_unauthenticated_paths             = ["/*"]
  alb_ingress_listener_unauthenticated_priority = 100
  alb_ingress_authenticated_paths               = []
}
