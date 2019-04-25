## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb_arn_suffix | The ARN suffix of the ALB | string | - | yes |
| alb_dns_name | DNS name of ALB | string | - | yes |
| alb_ingress_authenticated_hosts | Authenticated hosts to match in Hosts header (a maximum of 1 can be defined) | list | `<list>` | no |
| alb_ingress_authenticated_listener_arns | A list of authenticated ALB listener ARNs to attach ALB listener rules to | list | `<list>` | no |
| alb_ingress_authenticated_listener_arns_count | The number of authenticated ARNs in `alb_ingress_authenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | string | `0` | no |
| alb_ingress_authenticated_paths | Authenticated path pattern to match (a maximum of 1 can be defined) | list | `<list>` | no |
| alb_ingress_healthcheck_path | The path of the healthcheck which the ALB checks | string | `/` | no |
| alb_ingress_listener_authenticated_priority | The priority for the rules with authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_unauthenticated_priority` since a listener can't have multiple rules with the same priority | string | `100` | no |
| alb_ingress_listener_unauthenticated_priority | The priority for the rules without authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_authenticated_priority` since a listener can't have multiple rules with the same priority | string | `50` | no |
| alb_ingress_protocol | The protocol for generated ALB target group (if `target_group_arn` not set) | string | `HTTP` | no |
| alb_ingress_unauthenticated_hosts | Unauthenticated hosts to match in Hosts header (a maximum of 1 can be defined) | list | `<list>` | no |
| alb_ingress_unauthenticated_listener_arns | A list of unauthenticated ALB listener ARNs to attach ALB listener rules to | list | `<list>` | no |
| alb_ingress_unauthenticated_listener_arns_count | The number of unauthenticated ARNs in `alb_ingress_unauthenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | string | `0` | no |
| alb_ingress_unauthenticated_paths | Unauthenticated path pattern to match (a maximum of 1 can be defined) | list | `<list>` | no |
| alb_name | The Name of the ALB | string | - | yes |
| alb_target_group_alarms_3xx_threshold | The maximum number of 3XX HTTPCodes in a given period for ECS Service | string | `25` | no |
| alb_target_group_alarms_4xx_threshold | The maximum number of 4XX HTTPCodes in a given period for ECS Service | string | `25` | no |
| alb_target_group_alarms_5xx_threshold | The maximum number of 5XX HTTPCodes in a given period for ECS Service | string | `25` | no |
| alb_target_group_alarms_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an ALARM state from any other state. | list | `<list>` | no |
| alb_target_group_alarms_enabled | A boolean to enable/disable CloudWatch Alarms for ALB Target metrics | string | `false` | no |
| alb_target_group_alarms_evaluation_periods | The number of periods to analyze for ALB CloudWatch Alarms | string | `1` | no |
| alb_target_group_alarms_insufficient_data_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an INSUFFICIENT_DATA state from any other state. | list | `<list>` | no |
| alb_target_group_alarms_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an OK state from any other state. | list | `<list>` | no |
| alb_target_group_alarms_period | The period (in seconds) to analyze for ALB CloudWatch Alarms | string | `300` | no |
| alb_target_group_alarms_response_time_threshold | The maximum ALB Target Group response time | string | `0.5` | no |
| alb_zone_id | The ID of the zone in which ALB is provisioned | string | - | yes |
| atlantis_allow_repo_config | Allow Atlantis to use atlantis.yaml | string | `true` | no |
| atlantis_gh_team_whitelist | Atlantis GitHub team whitelist | string | `` | no |
| atlantis_gh_user | Atlantis GitHub user | string | - | yes |
| atlantis_gh_webhook_secret | Atlantis GitHub webhook secret | string | `` | no |
| atlantis_log_level | Atlantis log level | string | `info` | no |
| atlantis_port | Atlantis container port | string | `4141` | no |
| atlantis_repo_config | Path to atlantis config file | string | `atlantis.yaml` | no |
| atlantis_repo_whitelist | Whitelist of repositories Atlantis will accept webhooks from | list | `<list>` | no |
| atlantis_wake_word | Wake world for Atlantis | string | `atlantis` | no |
| atlantis_webhook_format | Template for the Atlantis webhook URL which is populated with the hostname | string | `https://%s/events` | no |
| attributes | Additional attributes (e.g. `1`) | list | `<list>` | no |
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
| authentication_type | Authentication type. Supported values are `COGNITO`, `OIDC`, `NONE` | string | `NONE` | no |
| autoscaling_dimension | Dimension to autoscale on (valid options: cpu, memory) | string | `memory` | no |
| autoscaling_enabled | A boolean to enable/disable Autoscaling policy for ECS Service | string | `false` | no |
| autoscaling_max_capacity | Atlantis maximum tasks to run | string | `1` | no |
| autoscaling_min_capacity | Atlantis minimum tasks to run | string | `1` | no |
| autoscaling_scale_down_adjustment | Scaling adjustment to make during scale down event | string | `-1` | no |
| autoscaling_scale_down_cooldown | Period (in seconds) to wait between scale down events | string | `300` | no |
| autoscaling_scale_up_adjustment | Scaling adjustment to make during scale up event | string | `1` | no |
| autoscaling_scale_up_cooldown | Period (in seconds) to wait between scale up events | string | `60` | no |
| badge_enabled | Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled | string | `false` | no |
| branch | Atlantis branch of the GitHub repository, _e.g._ `master` | string | `master` | no |
| build_image | Docker image for build environment, _e.g._ `aws/codebuild/docker:docker:17.09.0` | string | `aws/codebuild/docker:17.09.0` | no |
| build_timeout | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. | string | `5` | no |
| buildspec | Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) | string | `` | no |
| chamber_format | Format to store parameters in SSM, for consumption with chamber | string | `/%s/%s` | no |
| chamber_service | SSM parameter service name for use with chamber. This is used in chamber_format where /$chamber_service/$parameter would be the default. | string | `atlantis` | no |
| codepipeline_enabled | A boolean to enable/disable AWS Codepipeline and ECR | string | `true` | no |
| container_cpu | Atlantis CPUs per task | string | `256` | no |
| container_image | The default container image to use in container definition | string | `cloudposse/default-backend` | no |
| container_memory | Atlantis memory per task | string | `512` | no |
| container_memory_reservation | The amount of RAM (Soft Limit) to allow container to use in MB. This value must be less than container_memory if set | string | `` | no |
| container_port | The port number on the container bound to assigned host_port | string | `80` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| deregistration_delay | The amount of time to wait in seconds while deregistering target | string | `15` | no |
| desired_count | Atlantis desired number of tasks | string | `1` | no |
| ecs_alarms_cpu_utilization_high_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High Alarm action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_high_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_cpu_utilization_high_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High OK action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_high_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_cpu_utilization_high_threshold | The maximum percentage of CPU utilization average | string | `80` | no |
| ecs_alarms_cpu_utilization_low_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low Alarm action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_low_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_cpu_utilization_low_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low OK action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_low_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_cpu_utilization_low_threshold | The minimum percentage of CPU utilization average | string | `20` | no |
| ecs_alarms_enabled | A boolean to enable/disable CloudWatch Alarms for ECS Service metrics | string | `false` | no |
| ecs_alarms_memory_utilization_high_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High Alarm action | list | `<list>` | no |
| ecs_alarms_memory_utilization_high_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_memory_utilization_high_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High OK action | list | `<list>` | no |
| ecs_alarms_memory_utilization_high_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_memory_utilization_high_threshold | The maximum percentage of Memory utilization average | string | `80` | no |
| ecs_alarms_memory_utilization_low_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low Alarm action | list | `<list>` | no |
| ecs_alarms_memory_utilization_low_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_memory_utilization_low_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low OK action | list | `<list>` | no |
| ecs_alarms_memory_utilization_low_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_memory_utilization_low_threshold | The minimum percentage of Memory utilization average | string | `20` | no |
| ecs_cluster_arn | ARN of the ECS cluster to deploy Atlantis | string | - | yes |
| ecs_cluster_name | Name of the ECS cluster to deploy Atlantis | string | - | yes |
| ecs_private_subnet_ids | List of Private Subnet IDs to provision ECS Service onto | list | - | yes |
| ecs_security_group_ids | Additional Security Group IDs to allow into ECS Service | list | `<list>` | no |
| enabled | Whether to create the resources. Set to `false` to prevent the module from creating any resources | string | `false` | no |
| environment | The environment variables for the task definition. This is a list of maps | list | `<list>` | no |
| github_oauth_token | GitHub Oauth token. If not provided the token is looked up from SSM | string | `` | no |
| github_oauth_token_ssm_name | SSM param name to lookup GitHub OAuth token if not provided | string | `` | no |
| github_webhook_events | A list of events which should trigger the webhook. See a list of [available events](https://developer.github.com/v3/activity/events/types/) | list | `<list>` | no |
| health_check_grace_period_seconds | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200. Only valid for services configured to use load balancers | string | `0` | no |
| health_check_healthy_threshold | The number of consecutive health checks successes required before healthy | string | `2` | no |
| health_check_interval | The duration in seconds in between health checks | string | `15` | no |
| health_check_matcher | The HTTP response codes to indicate a healthy check | string | `200-399` | no |
| health_check_timeout | The amount of time to wait in seconds before failing a health check request | string | `10` | no |
| health_check_unhealthy_threshold | The number of consecutive health check failures required before unhealthy | string | `2` | no |
| healthcheck | A map containing command (string), interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy, and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries) | map | `<map>` | no |
| hostname | Atlantis URL | string | `` | no |
| kms_key_id | KMS key ID used to encrypt SSM SecureString parameters | string | `` | no |
| launch_type | The ECS launch type (valid options: FARGATE or EC2) | string | `FARGATE` | no |
| name | Application or solution name (e.g. `app`) | string | `ecs` | no |
| namespace | Namespace (e.g. `eg` or `cp`) | string | - | yes |
| overwrite_ssm_parameter | Whether to overwrite an existing SSM parameter | string | `true` | no |
| parent_zone_id | The zone ID where the DNS record for the `short_name` will be written | string | `` | no |
| policy_arn | Permission to grant to atlantis server | string | `arn:aws:iam::aws:policy/AdministratorAccess` | no |
| poll_source_changes | Periodically check the location of your source content and run the pipeline if changes are detected | string | `false` | no |
| port_mappings | The port mappings to configure for the container. This is a list of maps. Each map should contain "containerPort", "hostPort", and "protocol", where "protocol" is one of "tcp" or "udp". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort | list | `<list>` | no |
| region | AWS Region for Atlantis deployment | string | `us-west-2` | no |
| repo_name | GitHub repository name of the atlantis to be built and deployed to ECS. | string | - | yes |
| repo_owner | GitHub organization containing the Atlantis repository | string | - | yes |
| security_group_ids | Additional Security Group IDs to allow into ECS Service. | list | `<list>` | no |
| short_name | Alantis Short DNS name (E.g. `atlantis`) | string | `atlantis` | no |
| ssh_private_key_name | Atlantis SSH private key name | string | `atlantis_ssh_private_key` | no |
| ssh_public_key_name | Atlantis SSH public key name | string | `atlantis_ssh_public_key` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |
| target_group_arn | ALB target group ARN. If this is an empty string, a new one will be generated | string | `` | no |
| target_type | Target type | string | `ip` | no |
| vpc_id | VPC ID for the ECS Cluster | string | `` | no |
| webhook_authentication | The type of authentication to use. One of IP, GITHUB_HMAC, or UNAUTHENTICATED | string | `GITHUB_HMAC` | no |
| webhook_enabled | Set to false to prevent the module from creating any webhook resources | string | `true` | no |
| webhook_events | A list of events which should trigger the webhook. | list | `<list>` | no |
| webhook_filter_json_path | The JSON path to filter on | string | `$.ref` | no |
| webhook_filter_match_equals | The value to match on (e.g. refs/heads/{Branch}) | string | `refs/heads/{Branch}` | no |
| webhook_secret_length | GitHub webhook secret length | string | `32` | no |
| webhook_target_action | The name of the action in a pipeline you want to connect to the webhook. The action must be from the source (first) stage of the pipeline | string | `Source` | no |

## Outputs

| Name | Description |
|------|-------------|
| atlantis_ssh_public_key | Atlantis SSH Public Key |
| atlantis_url | The URL endpoint for the atlantis server |
| badge_url | The URL of the build badge when `badge_enabled` is enabled |

