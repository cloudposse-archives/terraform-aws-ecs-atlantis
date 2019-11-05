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

autoscaling_min_capacity = 1

autoscaling_max_capacity = 2

webhook_enabled = false

github_oauth_token = "test"

github_webhooks_token = "test"

codepipeline_s3_bucket_force_destroy = true

build_timeout = 20
