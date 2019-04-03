variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  default     = "eg"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = "testing"
}

variable "name" {
  type        = "string"
  description = "Application or solution name (e.g. `app`)"
  default     = "atlantis"
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

variable "region" {
  type        = "string"
  description = "AWS Region"
  default     = "us-west-2"
}

variable "certificate_arn" {
  type        = "string"
  description = "SSL certificate ARN for ALB HTTPS endpoints"
}

variable "cognito_user_pool_arn" {
  type        = "string"
  description = "Cognito User Pool ARN"
}

variable "cognito_user_pool_client_id" {
  type        = "string"
  description = "Cognito User Pool Client ID"
}

variable "cognito_user_pool_domain" {
  type        = "string"
  description = "Cognito User Pool Domain. The User Pool Domain should be set to the domain prefix (`xxx`) instead of full domain (https://xxx.auth.us-west-2.amazoncognito.com)"
}

variable "atlantis_gh_team_whitelist" {
  type        = "string"
  description = "Atlantis GitHub team whitelist"
  default     = "engineering:plan,devops:*"
}

variable "atlantis_gh_user" {
  type        = "string"
  description = "Atlantis GitHub user"
  default     = "examplebot"
}

variable "atlantis_repo_whitelist" {
  type        = "list"
  description = "Whitelist of repositories Atlantis will accept webhooks from"
  default     = ["github.com/example/*"]
}

variable "atlantis_repo_name" {
  type        = "string"
  description = "GitHub repository name of the atlantis to be built and deployed to ECS"
  default     = "atlantis"
}

variable "atlantis_repo_owner" {
  type        = "string"
  description = "GitHub organization containing the Atlantis repository"
  default     = "cloudposse"
}

variable "atlantis_branch" {
  type        = "string"
  description = "Atlantis branch of the GitHub repository, _e.g._ `master`"
  default     = "master"
}

variable "atlantis_container_cpu" {
  type        = "string"
  description = "The vCPU setting to control cpu limits of container. (If FARGATE launch type is used below, this must be a supported vCPU size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html)"
  default     = "256"
}

variable "atlantis_container_memory" {
  type        = "string"
  description = "The amount of RAM to allow container to use in MB. (If FARGATE launch type is used below, this must be a supported Memory size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html)"
  default     = "512"
}

variable "parent_zone_id" {
  type        = "string"
  description = "The zone ID where the DNS record for the atlantis `short_name` will be written"
}
