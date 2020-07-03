enabled = true

region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "ecs-atlantis"

vpc_cidr_block = "172.16.0.0/16"

container_cpu = 256

container_memory = 512

desired_count = 1

launch_type = "FARGATE"

authentication_type = ""

alb_ingress_listener_unauthenticated_priority = 1000

alb_ingress_unauthenticated_paths = ["/"]

autoscaling_enabled = true

autoscaling_min_capacity = 1

autoscaling_max_capacity = 2

webhook_enabled = false

github_oauth_token = "test"

github_webhooks_token = "test"

atlantis_gh_user = "test"

atlantis_gh_team_whitelist = "dev:plan,ops:*"

atlantis_repo_whitelist = ["cloudposse/terraform-aws-ecs-atlantis"]

codepipeline_enabled = true

codepipeline_s3_bucket_force_destroy = true

build_timeout = 20

repo_name = "atlantis"

repo_owner = "cloudposse"

branch = "master"

alb_target_group_alarms_enabled = true

ecs_alarms_enabled = true

parent_zone_id = "Z3SO0TKDDQ0RGG"

short_name = "ecs-atlantis-test"

default_backend_image = "cloudposse/default-backend:0.1.2"

chamber_service = "ecs-atlantis-test"
