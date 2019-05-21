variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `eg` or `cp`)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = "string"
  description = "Application or solution name (e.g. `app`)"
  default     = "ecs"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "default_backend_image" {
  type        = "string"
  default     = "cloudposse/default-backend:0.1.2"
  description = "ECS default (bootstrap) image"
}

variable "github_oauth_token" {
  type        = "string"
  description = "GitHub Oauth token. If not provided the token is looked up from SSM."
  default     = ""
}

variable "github_oauth_token_ssm_name" {
  type        = "string"
  description = "SSM param name to lookup GitHub OAuth token if not provided"
  default     = ""
}

variable "enabled" {
  type        = "string"
  default     = "false"
  description = "Whether to create the resources. Set to `false` to prevent the module from creating any resources"
}

variable "build_timeout" {
  default     = 5
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed."
}

variable "branch" {
  type        = "string"
  default     = "master"
  description = "Atlantis branch of the GitHub repository, _e.g._ `master`"
}

variable "repo_name" {
  type        = "string"
  description = "GitHub repository name of the atlantis to be built and deployed to ECS."
}

variable "repo_owner" {
  type        = "string"
  description = "GitHub organization containing the Atlantis repository"
}

variable "atlantis_repo_config" {
  type        = "string"
  description = "Path to atlantis server-side repo config file (https://www.runatlantis.io/docs/server-side-repo-config.html)"
  default     = "atlantis-repo-config.yaml"
}

variable "atlantis_repo_whitelist" {
  type        = "list"
  description = "Whitelist of repositories Atlantis will accept webhooks from"
  default     = []
}

variable "healthcheck_path" {
  type        = "string"
  description = "Healthcheck path"
  default     = "/healthz"
}

variable "chamber_format" {
  default     = "/%s/%s"
  description = "Format to store parameters in SSM, for consumption with chamber"
}

variable "chamber_service" {
  default     = "atlantis"
  description = "SSM parameter service name for use with chamber. This is used in chamber_format where /$chamber_service/$parameter would be the default."
}

variable "desired_count" {
  type        = "string"
  description = "Atlantis desired number of tasks"
  default     = "1"
}

variable "short_name" {
  description = "Alantis Short DNS name (E.g. `atlantis`)"
  default     = "atlantis"
}

variable "hostname" {
  type        = "string"
  description = "Atlantis URL"
  default     = ""
}

variable "atlantis_gh_user" {
  type        = "string"
  description = "Atlantis GitHub user"
}

variable "atlantis_gh_team_whitelist" {
  type        = "string"
  description = "Atlantis GitHub team whitelist"
  default     = ""
}

variable "atlantis_gh_webhook_secret" {
  type        = "string"
  description = "Atlantis GitHub webhook secret"
  default     = ""
}

variable "atlantis_log_level" {
  type        = "string"
  description = "Atlantis log level"
  default     = "info"
}

variable "atlantis_port" {
  type        = "string"
  description = "Atlantis container port"
  default     = "4141"
}

variable "atlantis_wake_word" {
  type        = "string"
  description = "Wake world for Atlantis"
  default     = "atlantis"
}

variable "atlantis_webhook_format" {
  type        = "string"
  default     = "https://%s/events"
  description = "Template for the Atlantis webhook URL which is populated with the hostname"
}

variable "atlantis_url_format" {
  type        = "string"
  default     = "https://%s"
  description = "Template for the Atlantis URL which is populated with the hostname"
}

variable "autoscaling_min_capacity" {
  type        = "string"
  description = "Atlantis minimum tasks to run"
  default     = "1"
}

variable "autoscaling_max_capacity" {
  type        = "string"
  description = "Atlantis maximum tasks to run"
  default     = "1"
}

variable "container_cpu" {
  type        = "string"
  description = "Atlantis CPUs per task"
  default     = "256"
}

variable "container_memory" {
  type        = "string"
  description = "Atlantis memory per task"
  default     = "512"
}

variable "policy_arn" {
  type        = "string"
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
  description = "Permission to grant to atlantis server"
}

variable "kms_key_id" {
  type        = "string"
  default     = ""
  description = "KMS key ID used to encrypt SSM SecureString parameters"
}

variable "webhook_secret_length" {
  default     = 32
  description = "GitHub webhook secret length"
}

variable "webhook_events" {
  type        = "list"
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
  type        = "string"
  default     = "atlantis_ssh_private_key"
  description = "Atlantis SSH private key name"
}

variable "ssh_public_key_name" {
  type        = "string"
  default     = "atlantis_ssh_public_key"
  description = "Atlantis SSH public key name"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID for the ECS Cluster"
}

variable "alb_name" {
  type        = "string"
  description = "The Name of the ALB"
}

variable "alb_arn_suffix" {
  type        = "string"
  description = "The ARN suffix of the ALB"
}

variable "alb_target_group_alarms_alarm_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an ALARM state from any other state."
  default     = []
}

variable "alb_target_group_alarms_ok_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an OK state from any other state."
  default     = []
}

variable "alb_target_group_alarms_insufficient_data_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an INSUFFICIENT_DATA state from any other state."
  default     = []
}

variable "alb_dns_name" {
  type        = "string"
  description = "DNS name of ALB"
}

variable "alb_zone_id" {
  type        = "string"
  description = "The ID of the zone in which ALB is provisioned"
}

variable "ecs_cluster_name" {
  type        = "string"
  description = "Name of the ECS cluster to deploy Atlantis"
}

variable "ecs_cluster_arn" {
  type        = "string"
  description = "ARN of the ECS cluster to deploy Atlantis"
}

variable "security_group_ids" {
  type        = "list"
  default     = []
  description = "Additional Security Group IDs to allow into ECS Service."
}

variable "private_subnet_ids" {
  type        = "list"
  default     = []
  description = "The private subnet IDs"
}

variable "region" {
  type        = "string"
  description = "AWS Region for Atlantis deployment"
  default     = "us-west-2"
}

variable "parent_zone_id" {
  type        = "string"
  description = "The zone ID where the DNS record for the `short_name` will be written"
  default     = ""
}

variable "overwrite_ssm_parameter" {
  type        = "string"
  default     = "true"
  description = "Whether to overwrite an existing SSM parameter"
}

variable "alb_ingress_listener_unauthenticated_priority" {
  type        = "string"
  default     = "50"
  description = "The priority for the rules without authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_authenticated_priority` since a listener can't have multiple rules with the same priority"
}

variable "alb_ingress_listener_authenticated_priority" {
  type        = "string"
  default     = "100"
  description = "The priority for the rules with authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_unauthenticated_priority` since a listener can't have multiple rules with the same priority"
}

variable "alb_ingress_unauthenticated_hosts" {
  type        = "list"
  default     = []
  description = "Unauthenticated hosts to match in Hosts header (a maximum of 1 can be defined)"
}

variable "alb_ingress_authenticated_hosts" {
  type        = "list"
  default     = []
  description = "Authenticated hosts to match in Hosts header (a maximum of 1 can be defined)"
}

variable "alb_ingress_unauthenticated_paths" {
  type        = "list"
  default     = ["/events"]
  description = "Unauthenticated path pattern to match (a maximum of 1 can be defined)"
}

variable "alb_ingress_authenticated_paths" {
  type        = "list"
  default     = ["/*"]
  description = "Authenticated path pattern to match (a maximum of 1 can be defined)"
}

variable "alb_ingress_unauthenticated_listener_arns" {
  type        = "list"
  default     = []
  description = "A list of unauthenticated ALB listener ARNs to attach ALB listener rules to"
}

variable "alb_ingress_unauthenticated_listener_arns_count" {
  type        = "string"
  default     = "0"
  description = "The number of unauthenticated ARNs in `alb_ingress_unauthenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed"
}

variable "alb_ingress_authenticated_listener_arns" {
  type        = "list"
  default     = []
  description = "A list of authenticated ALB listener ARNs to attach ALB listener rules to"
}

variable "alb_ingress_authenticated_listener_arns_count" {
  type        = "string"
  default     = "0"
  description = "The number of authenticated ARNs in `alb_ingress_authenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed"
}

variable "authentication_type" {
  type        = "string"
  default     = ""
  description = "Authentication type. Supported values are `COGNITO` and `OIDC`"
}

variable "authentication_cognito_user_pool_arn" {
  type        = "string"
  description = "Cognito User Pool ARN"
  default     = ""
}

variable "authentication_cognito_user_pool_client_id" {
  type        = "string"
  description = "Cognito User Pool Client ID"
  default     = ""
}

variable "authentication_cognito_user_pool_domain" {
  type        = "string"
  description = "Cognito User Pool Domain. The User Pool Domain should be set to the domain prefix (`xxx`) instead of full domain (https://xxx.auth.us-west-2.amazoncognito.com)"
  default     = ""
}

variable "authentication_oidc_client_id" {
  type        = "string"
  description = "OIDC Client ID"
  default     = ""
}

variable "authentication_oidc_client_secret" {
  type        = "string"
  description = "OIDC Client Secret"
  default     = ""
}

variable "authentication_oidc_issuer" {
  type        = "string"
  description = "OIDC Issuer"
  default     = ""
}

variable "authentication_oidc_authorization_endpoint" {
  type        = "string"
  description = "OIDC Authorization Endpoint"
  default     = ""
}

variable "authentication_oidc_token_endpoint" {
  type        = "string"
  description = "OIDC Token Endpoint"
  default     = ""
}

variable "authentication_oidc_user_info_endpoint" {
  type        = "string"
  description = "OIDC User Info Endpoint"
  default     = ""
}

variable "authentication_cognito_user_pool_arn_ssm_name" {
  type        = "string"
  description = "SSM param name to lookup `authentication_cognito_user_pool_arn` if not provided"
  default     = ""
}

variable "authentication_cognito_user_pool_client_id_ssm_name" {
  type        = "string"
  description = "SSM param name to lookup `authentication_cognito_user_pool_client_id` if not provided"
  default     = ""
}

variable "authentication_cognito_user_pool_domain_ssm_name" {
  type        = "string"
  description = "SSM param name to lookup `authentication_cognito_user_pool_domain` if not provided"
  default     = ""
}

variable "authentication_oidc_client_id_ssm_name" {
  type        = "string"
  description = "SSM param name to lookup `authentication_oidc_client_id` if not provided"
  default     = ""
}

variable "authentication_oidc_client_secret_ssm_name" {
  type        = "string"
  description = "SSM param name to lookup `authentication_oidc_client_secret` if not provided"
  default     = ""
}
