## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb_arn_suffix | The ARN suffix of the ALB | string | - | yes |
| alb_dns_name | DNS name of ALB | string | - | yes |
| alb_ingress_authenticated_hosts | Authenticated hosts to match in Hosts header (a maximum of 1 can be defined) | list(string) | `<list>` | no |
| alb_ingress_authenticated_listener_arns | A list of authenticated ALB listener ARNs to attach ALB listener rules to | list(string) | `<list>` | no |
| alb_ingress_authenticated_listener_arns_count | The number of authenticated ARNs in `alb_ingress_authenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | number | `0` | no |
| alb_ingress_authenticated_paths | Authenticated path pattern to match (a maximum of 1 can be defined) | list(string) | `<list>` | no |
| alb_ingress_listener_authenticated_priority | The priority for the rules with authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_unauthenticated_priority` since a listener can't have multiple rules with the same priority | number | `100` | no |
| alb_ingress_listener_unauthenticated_priority | The priority for the rules without authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_authenticated_priority` since a listener can't have multiple rules with the same priority | number | `50` | no |
| alb_ingress_unauthenticated_hosts | Unauthenticated hosts to match in Hosts header (a maximum of 1 can be defined) | list(string) | `<list>` | no |
| alb_ingress_unauthenticated_listener_arns | A list of unauthenticated ALB listener ARNs to attach ALB listener rules to | list(string) | `<list>` | no |
| alb_ingress_unauthenticated_listener_arns_count | The number of unauthenticated ARNs in `alb_ingress_unauthenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | number | `0` | no |
| alb_ingress_unauthenticated_paths | Unauthenticated path pattern to match (a maximum of 1 can be defined) | list(string) | `<list>` | no |
| alb_name | The Name of the ALB | string | - | yes |
| alb_security_group | Security group of the ALB | string | - | yes |
| alb_target_group_alarms_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an ALARM state from any other state. | list(string) | `<list>` | no |
| alb_target_group_alarms_insufficient_data_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an INSUFFICIENT_DATA state from any other state. | list(string) | `<list>` | no |
| alb_target_group_alarms_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an OK state from any other state. | list(string) | `<list>` | no |
| alb_zone_id | The ID of the zone in which ALB is provisioned | string | - | yes |
| atlantis_gh_team_whitelist | Atlantis GitHub team whitelist | string | `` | no |
| atlantis_gh_user | Atlantis GitHub user | string | - | yes |
| atlantis_gh_webhook_secret | Atlantis GitHub webhook secret | string | `` | no |
| atlantis_log_level | Atlantis log level | string | `info` | no |
| atlantis_port | Atlantis container port | number | `4141` | no |
| atlantis_repo_config | Path to atlantis server-side repo config file (https://www.runatlantis.io/docs/server-side-repo-config.html) | string | `atlantis-repo-config.yaml` | no |
| atlantis_repo_whitelist | Whitelist of repositories Atlantis will accept webhooks from | list(string) | `<list>` | no |
| atlantis_url_format | Template for the Atlantis URL which is populated with the hostname | string | `https://%s` | no |
| atlantis_wake_word | Wake world for atlantis | string | `atlantis` | no |
| atlantis_webhook_format | Template for the Atlantis webhook URL which is populated with the hostname | string | `https://%s/events` | no |
| attributes | Additional attributes (_e.g._ "1") | list(string) | `<list>` | no |
| authentication_cognito_user_pool_arn | Cognito User Pool ARN | string | `` | no |
| authentication_cognito_user_pool_arn_ssm_name | SSM param name to lookup `authentication_cognito_user_pool_arn` if not provided | string | `` | no |
| authentication_cognito_user_pool_client_id | Cognito User Pool Client ID | string | `` | no |
| authentication_cognito_user_pool_client_id_ssm_name | SSM param name to lookup `authentication_cognito_user_pool_client_id` if not provided | string | `` | no |
| authentication_cognito_user_pool_domain | Cognito User Pool Domain. The User Pool Domain should be set to the domain prefix (`xxx`) instead of full domain (https://xxx.auth.us-west-2.amazoncognito.com) | string | `` | no |
| authentication_cognito_user_pool_domain_ssm_name | SSM param name to lookup `authentication_cognito_user_pool_domain` if not provided | string | `` | no |
| authentication_oidc_authorization_endpoint | OIDC Authorization Endpoint | string | `` | no |
| authentication_oidc_client_id | OIDC Client ID | string | `` | no |
| authentication_oidc_client_id_ssm_name | SSM param name to lookup `authentication_oidc_client_id` if not provided | string | `` | no |
| authentication_oidc_client_secret | OIDC Client Secret | string | `` | no |
| authentication_oidc_client_secret_ssm_name | SSM param name to lookup `authentication_oidc_client_secret` if not provided | string | `` | no |
| authentication_oidc_issuer | OIDC Issuer | string | `` | no |
| authentication_oidc_token_endpoint | OIDC Token Endpoint | string | `` | no |
| authentication_oidc_user_info_endpoint | OIDC User Info Endpoint | string | `` | no |
| authentication_type | Authentication type. Supported values are `COGNITO` and `OIDC` | string | `` | no |
| autoscaling_max_capacity | Atlantis maximum tasks to run | number | `1` | no |
| autoscaling_min_capacity | Atlantis minimum tasks to run | number | `1` | no |
| branch | Atlantis branch of the GitHub repository, _e.g._ `master` | string | `master` | no |
| build_timeout | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. | number | `10` | no |
| chamber_format | Format to store parameters in SSM, for consumption with chamber | string | `/%s/%s` | no |
| chamber_service | SSM parameter service name for use with chamber. This is used in chamber_format where /$chamber_service/$parameter would be the default. | string | `atlantis` | no |
| codepipeline_s3_bucket_force_destroy | A boolean that indicates all objects should be deleted from the CodePipeline artifact store S3 bucket so that the bucket can be destroyed without error | bool | `false` | no |
| container_cpu | Atlantis CPUs per task | number | `256` | no |
| container_memory | Atlantis memory per task | number | `512` | no |
| default_backend_image | ECS default (bootstrap) image | string | `cloudposse/default-backend:0.1.2` | no |
| delimiter | Delimiter between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| desired_count | Atlantis desired number of tasks | number | `1` | no |
| ecs_cluster_arn | ARN of the ECS cluster to deploy Atlantis | string | - | yes |
| ecs_cluster_name | Name of the ECS cluster to deploy Atlantis | string | - | yes |
| enabled | Whether to create the resources. Set to `false` to prevent the module from creating any resources | bool | `false` | no |
| github_oauth_token | GitHub OAuth token. If not provided the token is looked up from SSM | string | `` | no |
| github_oauth_token_ssm_name | SSM param name to lookup `github_oauth_token` if not provided | string | `` | no |
| github_webhooks_token | GitHub OAuth Token with permissions to create webhooks. If not provided the token is looked up from SSM | string | `` | no |
| github_webhooks_token_ssm_name | SSM param name to lookup `github_webhooks_token` if not provided | string | `` | no |
| healthcheck_path | Healthcheck path | string | `/healthz` | no |
| hostname | Atlantis URL | string | `` | no |
| kms_key_id | KMS key ID used to encrypt SSM SecureString parameters | string | `` | no |
| launch_type | The ECS launch type (valid options: FARGATE or EC2) | string | `FARGATE` | no |
| name | Name of the application | string | - | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | string | `` | no |
| overwrite_ssm_parameter | Whether to overwrite an existing SSM parameter | bool | `true` | no |
| parent_zone_id | The zone ID where the DNS record for the `short_name` will be written | string | `` | no |
| policy_arn | Permission to grant to atlantis server | string | `arn:aws:iam::aws:policy/AdministratorAccess` | no |
| private_subnet_ids | The private subnet IDs | list(string) | `<list>` | no |
| region | AWS Region for S3 bucket | string | - | yes |
| repo_name | GitHub repository name of the atlantis to be built and deployed to ECS. | string | - | yes |
| repo_owner | GitHub organization containing the Atlantis repository | string | - | yes |
| security_group_ids | Additional Security Group IDs to allow into ECS Service. | list(string) | `<list>` | no |
| short_name | Alantis Short DNS name (E.g. `atlantis`) | string | `atlantis` | no |
| ssh_private_key_name | Atlantis SSH private key name | string | `atlantis_ssh_private_key` | no |
| ssh_public_key_name | Atlantis SSH public key name | string | `atlantis_ssh_public_key` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | `` | no |
| tags | Additional tags (_e.g._ { BusinessUnit : ABC }) | map(string) | `<map>` | no |
| vpc_id | VPC ID for the ECS Cluster | string | - | yes |
| webhook_enabled | Set to false to prevent the module from creating any webhook resources | bool | `true` | no |
| webhook_events | A list of events which should trigger the webhook. | list(string) | `<list>` | no |
| webhook_secret_length | GitHub webhook secret length | number | `32` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_ingress_target_group_arn | ALB Target Group ARN |
| alb_ingress_target_group_arn_suffix | ALB Target Group ARN suffix |
| alb_ingress_target_group_name | ALB Target Group name |
| atlantis_ssh_public_key | Atlantis SSH Public Key |
| atlantis_url | The URL endpoint for the atlantis server |
| atlantis_webhook_url | atlantis webhook URL |
| codebuild_badge_url | The URL of the build badge when badge_enabled is enabled |
| codebuild_cache_bucket_arn | CodeBuild cache S3 bucket ARN |
| codebuild_cache_bucket_name | CodeBuild cache S3 bucket name |
| codebuild_project_id | CodeBuild project ID |
| codebuild_project_name | CodeBuild project name |
| codebuild_role_arn | CodeBuild IAM Role ARN |
| codebuild_role_id | CodeBuild IAM Role ID |
| codepipeline_arn | CodePipeline ARN |
| codepipeline_id | CodePipeline ID |
| codepipeline_webhook_id | The CodePipeline webhook's ID |
| codepipeline_webhook_url | The CodePipeline webhook's URL. POST events to this endpoint to trigger the target |
| container_definition_json | JSON encoded list of container definitions for use with other terraform resources such as aws_ecs_task_definition |
| container_definition_json_map | JSON encoded container definitions for use with other terraform resources such as aws_ecs_task_definition |
| ecr_registry_id | Registry ID |
| ecr_registry_url | Registry URL |
| ecr_repository_name | Registry name |
| ecs_alarms_cpu_utilization_high_cloudwatch_metric_alarm_arn | ECS CPU utilization high CloudWatch metric alarm ARN |
| ecs_alarms_cpu_utilization_high_cloudwatch_metric_alarm_id | ECS CPU utilization high CloudWatch metric alarm ID |
| ecs_alarms_cpu_utilization_low_cloudwatch_metric_alarm_arn | ECS CPU utilization low CloudWatch metric alarm ARN |
| ecs_alarms_cpu_utilization_low_cloudwatch_metric_alarm_id | ECS CPU utilization low CloudWatch metric alarm ID |
| ecs_alarms_memory_utilization_high_cloudwatch_metric_alarm_arn | ECS Memory utilization high CloudWatch metric alarm ARN |
| ecs_alarms_memory_utilization_high_cloudwatch_metric_alarm_id | ECS Memory utilization high CloudWatch metric alarm ID |
| ecs_alarms_memory_utilization_low_cloudwatch_metric_alarm_arn | ECS Memory utilization low CloudWatch metric alarm ARN |
| ecs_alarms_memory_utilization_low_cloudwatch_metric_alarm_id | ECS Memory utilization low CloudWatch metric alarm ID |
| ecs_cloudwatch_autoscaling_scale_down_policy_arn | ARN of the scale down policy |
| ecs_cloudwatch_autoscaling_scale_up_policy_arn | ARN of the scale up policy |
| ecs_exec_role_policy_id | The ECS service role policy ID, in the form of `role_name:role_policy_name` |
| ecs_exec_role_policy_name | ECS service role name |
| ecs_service_name | ECS Service name |
| ecs_service_role_arn | ECS Service role ARN |
| ecs_service_security_group_id | Security Group ID of the ECS task |
| ecs_task_definition_family | ECS task definition family |
| ecs_task_definition_revision | ECS task definition revision |
| ecs_task_exec_role_arn | ECS Task exec role ARN |
| ecs_task_exec_role_name | ECS Task role name |
| ecs_task_role_arn | ECS Task role ARN |
| ecs_task_role_id | ECS Task role id |
| ecs_task_role_name | ECS Task role name |
| httpcode_elb_5xx_count_cloudwatch_metric_alarm_arn | ALB 5xx count CloudWatch metric alarm ARN |
| httpcode_elb_5xx_count_cloudwatch_metric_alarm_id | ALB 5xx count CloudWatch metric alarm ID |
| httpcode_target_3xx_count_cloudwatch_metric_alarm_arn | ALB Target Group 3xx count CloudWatch metric alarm ARN |
| httpcode_target_3xx_count_cloudwatch_metric_alarm_id | ALB Target Group 3xx count CloudWatch metric alarm ID |
| httpcode_target_4xx_count_cloudwatch_metric_alarm_arn | ALB Target Group 4xx count CloudWatch metric alarm ARN |
| httpcode_target_4xx_count_cloudwatch_metric_alarm_id | ALB Target Group 4xx count CloudWatch metric alarm ID |
| httpcode_target_5xx_count_cloudwatch_metric_alarm_arn | ALB Target Group 5xx count CloudWatch metric alarm ARN |
| httpcode_target_5xx_count_cloudwatch_metric_alarm_id | ALB Target Group 5xx count CloudWatch metric alarm ID |
| target_response_time_average_cloudwatch_metric_alarm_arn | ALB Target Group response time average CloudWatch metric alarm ARN |
| target_response_time_average_cloudwatch_metric_alarm_id | ALB Target Group response time average CloudWatch metric alarm ID |

