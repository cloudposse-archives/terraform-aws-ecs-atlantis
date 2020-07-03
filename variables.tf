variable "region" {
  type        = string
  description = "AWS Region for S3 bucket"
}

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cp`)"
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = ""
}

variable "name" {
  type        = string
  description = "Name of the application"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes (_e.g._ \"1\")"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ { BusinessUnit : ABC })"
  default     = {}
}

variable "launch_type" {
  type        = string
  description = "The ECS launch type (valid options: FARGATE or EC2)"
  default     = "FARGATE"
}

variable "default_backend_image" {
  type        = string
  default     = "cloudposse/default-backend:0.1.2"
  description = "ECS default (bootstrap) image"
}

variable "github_oauth_token" {
  type        = string
  description = "GitHub OAuth token. If not provided the token is looked up from SSM"
  default     = ""
}

variable "github_webhooks_token" {
  type        = string
  description = "GitHub OAuth Token with permissions to create webhooks. If not provided the token is looked up from SSM"
  default     = ""
}

variable "github_anonymous" {
  type        = bool
  description = "Github Anonymous API (if `true`, token must not be set as GITHUB_TOKEN or `github_token`)"
  default     = false
}

variable "github_oauth_token_ssm_name" {
  type        = string
  description = "SSM param name to lookup `github_oauth_token` if not provided"
  default     = ""
}

variable "github_webhooks_token_ssm_name" {
  type        = string
  description = "SSM param name to lookup `github_webhooks_token` if not provided"
  default     = ""
}

variable "codepipeline_s3_bucket_force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the CodePipeline artifact store S3 bucket so that the bucket can be destroyed without error"
  default     = false
}

variable "enabled" {
  type        = bool
  default     = false
  description = "Whether to create the resources. Set to `false` to prevent the module from creating any resources"
}

variable "codepipeline_enabled" {
  type        = bool
  description = "A boolean to enable/disable AWS Codepipeline and ECR"
  default     = false
}

variable "build_timeout" {
  type        = number
  default     = 10
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed."
}

variable "branch" {
  type        = string
  default     = "master"
  description = "Atlantis branch of the GitHub repository, _e.g._ `master`"
}

variable "repo_name" {
  type        = string
  description = "GitHub repository name of the atlantis to be built and deployed to ECS."
}

variable "repo_owner" {
  type        = string
  description = "GitHub organization containing the Atlantis repository"
}

variable "atlantis_repo_config" {
  type        = string
  description = "Path to atlantis server-side repo config file (https://www.runatlantis.io/docs/server-side-repo-config.html)"
  default     = "atlantis-repo-config.yaml"
}

variable "atlantis_repo_whitelist" {
  type        = list(string)
  description = "Whitelist of repositories Atlantis will accept webhooks from"
  default     = []
}

variable "autoscaling_enabled" {
  type        = bool
  description = "A boolean to enable/disable Autoscaling policy for ECS Service"
  default     = false
}

variable "healthcheck_path" {
  type        = string
  description = "Healthcheck path"
  default     = "/healthz"
}

variable "chamber_format" {
  type        = string
  default     = "/%s/%s"
  description = "Format to store parameters in SSM, for consumption with chamber"
}

variable "chamber_service" {
  type        = string
  default     = "atlantis"
  description = "SSM parameter service name for use with chamber. This is used in chamber_format where /$chamber_service/$parameter would be the default."
}

variable "desired_count" {
  type        = number
  description = "Atlantis desired number of tasks"
  default     = 1
}

variable "short_name" {
  type        = string
  description = "Alantis short DNS name (e.g. `atlantis`)"
  default     = "atlantis"
}

variable "hostname" {
  type        = string
  description = "Atlantis URL"
  default     = ""
}

variable "atlantis_gh_user" {
  type        = string
  description = "Atlantis GitHub user"
}

variable "atlantis_gh_team_whitelist" {
  type        = string
  description = "Atlantis GitHub team whitelist"
  default     = ""
}

variable "atlantis_gh_webhook_secret" {
  type        = string
  description = "Atlantis GitHub webhook secret"
  default     = ""
}

variable "atlantis_log_level" {
  type        = string
  description = "Atlantis log level"
  default     = "info"
}

variable "atlantis_port" {
  type        = number
  description = "Atlantis container port"
  default     = 4141
}

variable "atlantis_wake_word" {
  type        = string
  description = "Wake world for atlantis"
  default     = "atlantis"
}

variable "atlantis_webhook_format" {
  type        = string
  default     = "https://%s/events"
  description = "Template for the Atlantis webhook URL which is populated with the hostname"
}

variable "atlantis_url_format" {
  type        = string
  default     = "https://%s"
  description = "Template for the Atlantis URL which is populated with the hostname"
}

variable "autoscaling_min_capacity" {
  type        = number
  description = "Atlantis minimum tasks to run"
  default     = 1
}

variable "autoscaling_max_capacity" {
  type        = number
  description = "Atlantis maximum tasks to run"
  default     = 1
}

variable "container_cpu" {
  type        = number
  description = "Atlantis CPUs per task"
  default     = 256
}

variable "container_memory" {
  type        = number
  description = "Atlantis memory per task"
  default     = 512
}

variable "policy_arn" {
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
  description = "Permission to grant to atlantis server"
}

variable "kms_key_id" {
  type        = string
  default     = ""
  description = "KMS key ID used to encrypt SSM SecureString parameters"
}

variable "webhook_enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any webhook resources"
  default     = true
}

variable "webhook_secret_length" {
  type        = number
  default     = 32
  description = "GitHub webhook secret length"
}

variable "webhook_events" {
  type        = list(string)
  description = "A list of events which should trigger the webhook."

  default = [
    "issue_comment",
    "pull_request",
    "pull_request_review",
    "pull_request_review_comment",
    "push",
  ]
}

variable "ssh_private_key_name" {
  type        = string
  default     = "atlantis_ssh_private_key"
  description = "Atlantis SSH private key name"
}

variable "ssh_public_key_name" {
  type        = string
  default     = "atlantis_ssh_public_key"
  description = "Atlantis SSH public key name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the ECS Cluster"
}

variable "alb_arn_suffix" {
  type        = string
  description = "The ARN suffix of the ALB"
}

variable "alb_security_group" {
  type        = string
  description = "Security group of the ALB"
}

variable "alb_target_group_alarms_alarm_actions" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an ALARM state from any other state."
  default     = []
}

variable "alb_target_group_alarms_ok_actions" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an OK state from any other state."
  default     = []
}

variable "alb_target_group_alarms_insufficient_data_actions" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an INSUFFICIENT_DATA state from any other state."
  default     = []
}

variable "ecs_alarms_cpu_utilization_high_alarm_actions" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High Alarm action"
  default     = []
}

variable "ecs_alarms_cpu_utilization_high_ok_actions" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High OK action"
  default     = []
}

variable "ecs_alarms_cpu_utilization_low_alarm_actions" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low Alarm action"
  default     = []
}

variable "ecs_alarms_cpu_utilization_low_ok_actions" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low OK action"
  default     = []
}

variable "ecs_alarms_memory_utilization_high_alarm_actions" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High Alarm action"
  default     = []
}

variable "ecs_alarms_memory_utilization_high_ok_actions" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High OK action"
  default     = []
}

variable "ecs_alarms_memory_utilization_low_alarm_actions" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low Alarm action"
  default     = []
}

variable "ecs_alarms_memory_utilization_low_ok_actions" {
  type        = list(string)
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low OK action"
  default     = []
}

variable "alb_dns_name" {
  type        = string
  description = "DNS name of ALB"
}

variable "alb_zone_id" {
  type        = string
  description = "The ID of the zone in which ALB is provisioned"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster to deploy Atlantis"
}

variable "ecs_cluster_arn" {
  type        = string
  description = "ARN of the ECS cluster to deploy Atlantis"
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Additional Security Group IDs to allow into ECS Service."
}

variable "private_subnet_ids" {
  type        = list(string)
  default     = []
  description = "The private subnet IDs"
}

variable "parent_zone_id" {
  type        = string
  description = "The zone ID where the DNS record for the `short_name` will be written"
  default     = ""
}

variable "overwrite_ssm_parameter" {
  type        = bool
  default     = true
  description = "Whether to overwrite an existing SSM parameter"
}

variable "alb_ingress_listener_unauthenticated_priority" {
  type        = number
  default     = 50
  description = "The priority for the rules without authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_authenticated_priority` since a listener can't have multiple rules with the same priority"
}

variable "alb_ingress_listener_authenticated_priority" {
  type        = number
  default     = 100
  description = "The priority for the rules with authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_unauthenticated_priority` since a listener can't have multiple rules with the same priority"
}

variable "alb_ingress_unauthenticated_hosts" {
  type        = list(string)
  default     = []
  description = "Unauthenticated hosts to match in Hosts header (a maximum of 1 can be defined)"
}

variable "alb_ingress_authenticated_hosts" {
  type        = list(string)
  default     = []
  description = "Authenticated hosts to match in Hosts header (a maximum of 1 can be defined)"
}

variable "alb_ingress_unauthenticated_paths" {
  type        = list(string)
  default     = ["/events"]
  description = "Unauthenticated path pattern to match (a maximum of 1 can be defined)"
}

variable "alb_ingress_authenticated_paths" {
  type        = list(string)
  default     = ["/*"]
  description = "Authenticated path pattern to match (a maximum of 1 can be defined)"
}

variable "alb_ingress_unauthenticated_listener_arns" {
  type        = list(string)
  default     = []
  description = "A list of unauthenticated ALB listener ARNs to attach ALB listener rules to"
}

variable "alb_ingress_unauthenticated_listener_arns_count" {
  type        = number
  default     = 0
  description = "The number of unauthenticated ARNs in `alb_ingress_unauthenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed"
}

variable "alb_ingress_authenticated_listener_arns" {
  type        = list(string)
  default     = []
  description = "A list of authenticated ALB listener ARNs to attach ALB listener rules to"
}

variable "alb_ingress_authenticated_listener_arns_count" {
  type        = number
  default     = 0
  description = "The number of authenticated ARNs in `alb_ingress_authenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed"
}

variable "authentication_type" {
  type        = string
  default     = ""
  description = "Authentication type. Supported values are `COGNITO` and `OIDC`"
}

variable "authentication_cognito_user_pool_arn" {
  type        = string
  description = "Cognito User Pool ARN"
  default     = ""
}

variable "authentication_cognito_user_pool_client_id" {
  type        = string
  description = "Cognito User Pool Client ID"
  default     = ""
}

variable "authentication_cognito_user_pool_domain" {
  type        = string
  description = "Cognito User Pool Domain. The User Pool Domain should be set to the domain prefix (`xxx`) instead of full domain (https://xxx.auth.us-west-2.amazoncognito.com)"
  default     = ""
}

variable "authentication_oidc_client_id" {
  type        = string
  description = "OIDC Client ID"
  default     = ""
}

variable "authentication_oidc_client_secret" {
  type        = string
  description = "OIDC Client Secret"
  default     = ""
}

variable "authentication_oidc_issuer" {
  type        = string
  description = "OIDC Issuer"
  default     = ""
}

variable "authentication_oidc_authorization_endpoint" {
  type        = string
  description = "OIDC Authorization Endpoint"
  default     = ""
}

variable "authentication_oidc_token_endpoint" {
  type        = string
  description = "OIDC Token Endpoint"
  default     = ""
}

variable "authentication_oidc_user_info_endpoint" {
  type        = string
  description = "OIDC User Info Endpoint"
  default     = ""
}

variable "authentication_cognito_user_pool_arn_ssm_name" {
  type        = string
  description = "SSM param name to lookup `authentication_cognito_user_pool_arn` if not provided"
  default     = ""
}

variable "authentication_cognito_user_pool_client_id_ssm_name" {
  type        = string
  description = "SSM param name to lookup `authentication_cognito_user_pool_client_id` if not provided"
  default     = ""
}

variable "authentication_cognito_user_pool_domain_ssm_name" {
  type        = string
  description = "SSM param name to lookup `authentication_cognito_user_pool_domain` if not provided"
  default     = ""
}

variable "authentication_oidc_client_id_ssm_name" {
  type        = string
  description = "SSM param name to lookup `authentication_oidc_client_id` if not provided"
  default     = ""
}

variable "authentication_oidc_client_secret_ssm_name" {
  type        = string
  description = "SSM param name to lookup `authentication_oidc_client_secret` if not provided"
  default     = ""
}

variable "alb_target_group_alarms_enabled" {
  type        = bool
  description = "A boolean to enable/disable CloudWatch Alarms for ALB Target metrics"
  default     = false
}

variable "ecs_alarms_enabled" {
  type        = bool
  description = "A boolean to enable/disable CloudWatch Alarms for ECS Service metrics"
  default     = false
}
