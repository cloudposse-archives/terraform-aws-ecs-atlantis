## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb_arn_suffix | The ARN suffix of the ALB | string | - | yes |
| alb_dns_name | DNS name of ALB | string | - | yes |
| alb_ingress_paths | Path pattern to match (a maximum of 1 can be defined), at least one of hosts or paths must be set | list | `<list>` | no |
| alb_listener_arns | A list of ALB listener ARNs | list | - | yes |
| alb_name | The Name of the ALB | string | - | yes |
| alb_target_group_alarms_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an ALARM state from any other state. | list | `<list>` | no |
| alb_target_group_alarms_insufficient_data_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an INSUFFICIENT_DATA state from any other state. | list | `<list>` | no |
| alb_target_group_alarms_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an OK state from any other state. | list | `<list>` | no |
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
| autoscaling_max_capacity | Atlantis maximum tasks to run | string | `1` | no |
| autoscaling_min_capacity | Atlantis minimum tasks to run | string | `1` | no |
| branch | Atlantis branch of the GitHub repository, _e.g._ `master` | string | `master` | no |
| build_timeout | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. | string | `5` | no |
| chamber_format | Format to store parameters in SSM, for consumption with chamber | string | `/%s/%s` | no |
| chamber_service | SSM parameter service name for use with chamber. This is used in chamber_format where /$chamber_service/$parameter would be the default. | string | `atlantis` | no |
| container_cpu | Atlantis CPUs per task | string | `256` | no |
| container_memory | Atlantis memory per task | string | `512` | no |
| default_backend_image | ECS default (bootstrap) image | string | `cloudposse/default-backend:0.1.2` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| desired_count | Atlantis desired number of tasks | string | `1` | no |
| domain_name | A domain name for which the certificate should be issued | string | - | yes |
| ecs_cluster_arn | ARN of the ECS cluster to deploy Atlantis | string | - | yes |
| ecs_cluster_name | Name of the ECS cluster to deploy Atlantis | string | - | yes |
| enabled | Whether to create the resources. Set to `false` to prevent the module from creating any resources | string | `false` | no |
| github_oauth_token | GitHub Oauth token. If not provided the token is looked up from SSM. | string | `` | no |
| github_oauth_token_ssm_name | SSM param name to lookup GitHub OAuth token if not provided | string | `` | no |
| healthcheck_path | Healthcheck path | string | `/healthz` | no |
| hostname | Atlantis URL | string | `` | no |
| kms_key_id | KMS key ID used to encrypt SSM SecureString parameters | string | `` | no |
| name | Application or solution name (e.g. `app`) | string | `ecs` | no |
| namespace | Namespace (e.g. `eg` or `cp`) | string | - | yes |
| overwrite_ssm_parameter | Whether to overwrite an existing SSM parameter | string | `true` | no |
| parent_zone_id | The zone ID of the `domain_name`. Leave blank and it will be looked up using the `domain_name`. Define it to avoid cold-start problems. | string | `` | no |
| policy_arn | Permission to grant to atlantis server | string | `arn:aws:iam::aws:policy/AdministratorAccess` | no |
| private_subnet_ids | The private subnet IDs | list | `<list>` | no |
| region | AWS Region for Atlantis deployment | string | `us-west-2` | no |
| repo_name | GitHub repository name of the atlantis to be built and deployed to ECS. | string | - | yes |
| repo_owner | GitHub organization containing the Atlantis repository | string | - | yes |
| security_group_ids | Additional Security Group IDs to allow into ECS Service. | list | `<list>` | no |
| short_name | Alantis Short DNS name (E.g. `atlantis`) | string | `atlantis` | no |
| ssh_private_key_name | Atlantis SSH private key name | string | `atlantis_ssh_private_key` | no |
| ssh_public_key_name | Atlantis SSH public key name | string | `atlantis_ssh_public_key` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |
| vpc_id | VPC ID for the ECS Cluster | string | - | yes |
| webhook_events | A list of events which should trigger the webhook. | list | `<list>` | no |
| webhook_secret_length | GitHub webhook secret length | string | `32` | no |

## Outputs

| Name | Description |
|------|-------------|
| atlantis_ssh_public_key | Atlantis SSH Public Key |
| badge_url | the url of the build badge when badge_enabled is enabled |

