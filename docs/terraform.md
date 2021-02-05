<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | >= 2.0 |
| random | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |
| random | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| alb\_arn\_suffix | The ARN suffix of the ALB | `string` | n/a | yes |
| alb\_dns\_name | DNS name of ALB | `string` | n/a | yes |
| alb\_ingress\_authenticated\_hosts | Authenticated hosts to match in Hosts header (a maximum of 1 can be defined) | `list(string)` | `[]` | no |
| alb\_ingress\_authenticated\_listener\_arns | A list of authenticated ALB listener ARNs to attach ALB listener rules to | `list(string)` | `[]` | no |
| alb\_ingress\_authenticated\_listener\_arns\_count | The number of authenticated ARNs in `alb_ingress_authenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | `number` | `0` | no |
| alb\_ingress\_authenticated\_paths | Authenticated path pattern to match (a maximum of 1 can be defined) | `list(string)` | <pre>[<br>  "/*"<br>]</pre> | no |
| alb\_ingress\_listener\_authenticated\_priority | The priority for the rules with authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_unauthenticated_priority` since a listener can't have multiple rules with the same priority | `number` | `100` | no |
| alb\_ingress\_listener\_unauthenticated\_priority | The priority for the rules without authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_authenticated_priority` since a listener can't have multiple rules with the same priority | `number` | `50` | no |
| alb\_ingress\_unauthenticated\_hosts | Unauthenticated hosts to match in Hosts header (a maximum of 1 can be defined) | `list(string)` | `[]` | no |
| alb\_ingress\_unauthenticated\_listener\_arns | A list of unauthenticated ALB listener ARNs to attach ALB listener rules to | `list(string)` | `[]` | no |
| alb\_ingress\_unauthenticated\_listener\_arns\_count | The number of unauthenticated ARNs in `alb_ingress_unauthenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | `number` | `0` | no |
| alb\_ingress\_unauthenticated\_paths | Unauthenticated path pattern to match (a maximum of 1 can be defined) | `list(string)` | <pre>[<br>  "/events"<br>]</pre> | no |
| alb\_security\_group | Security group of the ALB | `string` | n/a | yes |
| alb\_target\_group\_alarms\_alarm\_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an ALARM state from any other state. | `list(string)` | `[]` | no |
| alb\_target\_group\_alarms\_enabled | A boolean to enable/disable CloudWatch Alarms for ALB Target metrics | `bool` | `false` | no |
| alb\_target\_group\_alarms\_insufficient\_data\_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an INSUFFICIENT\_DATA state from any other state. | `list(string)` | `[]` | no |
| alb\_target\_group\_alarms\_ok\_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an OK state from any other state. | `list(string)` | `[]` | no |
| alb\_zone\_id | The ID of the zone in which ALB is provisioned | `string` | n/a | yes |
| atlantis\_gh\_team\_whitelist | Atlantis GitHub team whitelist | `string` | `""` | no |
| atlantis\_gh\_user | Atlantis GitHub user | `string` | n/a | yes |
| atlantis\_gh\_webhook\_secret | Atlantis GitHub webhook secret | `string` | `""` | no |
| atlantis\_log\_level | Atlantis log level | `string` | `"info"` | no |
| atlantis\_port | Atlantis container port | `number` | `4141` | no |
| atlantis\_repo\_config | Path to atlantis server-side repo config file (https://www.runatlantis.io/docs/server-side-repo-config.html) | `string` | `"atlantis-repo-config.yaml"` | no |
| atlantis\_repo\_whitelist | Whitelist of repositories Atlantis will accept webhooks from | `list(string)` | `[]` | no |
| atlantis\_url\_format | Template for the Atlantis URL which is populated with the hostname | `string` | `"https://%s"` | no |
| atlantis\_wake\_word | Wake world for atlantis | `string` | `"atlantis"` | no |
| atlantis\_webhook\_format | Template for the Atlantis webhook URL which is populated with the hostname | `string` | `"https://%s/events"` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| authentication\_cognito\_user\_pool\_arn | Cognito User Pool ARN | `string` | `""` | no |
| authentication\_cognito\_user\_pool\_arn\_ssm\_name | SSM param name to lookup `authentication_cognito_user_pool_arn` if not provided | `string` | `""` | no |
| authentication\_cognito\_user\_pool\_client\_id | Cognito User Pool Client ID | `string` | `""` | no |
| authentication\_cognito\_user\_pool\_client\_id\_ssm\_name | SSM param name to lookup `authentication_cognito_user_pool_client_id` if not provided | `string` | `""` | no |
| authentication\_cognito\_user\_pool\_domain | Cognito User Pool Domain. The User Pool Domain should be set to the domain prefix (`xxx`) instead of full domain (https://xxx.auth.us-west-2.amazoncognito.com) | `string` | `""` | no |
| authentication\_cognito\_user\_pool\_domain\_ssm\_name | SSM param name to lookup `authentication_cognito_user_pool_domain` if not provided | `string` | `""` | no |
| authentication\_oidc\_authorization\_endpoint | OIDC Authorization Endpoint | `string` | `""` | no |
| authentication\_oidc\_client\_id | OIDC Client ID | `string` | `""` | no |
| authentication\_oidc\_client\_id\_ssm\_name | SSM param name to lookup `authentication_oidc_client_id` if not provided | `string` | `""` | no |
| authentication\_oidc\_client\_secret | OIDC Client Secret | `string` | `""` | no |
| authentication\_oidc\_client\_secret\_ssm\_name | SSM param name to lookup `authentication_oidc_client_secret` if not provided | `string` | `""` | no |
| authentication\_oidc\_issuer | OIDC Issuer | `string` | `""` | no |
| authentication\_oidc\_token\_endpoint | OIDC Token Endpoint | `string` | `""` | no |
| authentication\_oidc\_user\_info\_endpoint | OIDC User Info Endpoint | `string` | `""` | no |
| authentication\_type | Authentication type. Supported values are `COGNITO` and `OIDC` | `string` | `""` | no |
| autoscaling\_enabled | A boolean to enable/disable Autoscaling policy for ECS Service | `bool` | `false` | no |
| autoscaling\_max\_capacity | Atlantis maximum tasks to run | `number` | `1` | no |
| autoscaling\_min\_capacity | Atlantis minimum tasks to run | `number` | `1` | no |
| branch | Atlantis branch of the GitHub repository, _e.g._ `master` | `string` | `"master"` | no |
| build\_timeout | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. | `number` | `10` | no |
| chamber\_format | Format to store parameters in SSM, for consumption with chamber | `string` | `"/%s/%s"` | no |
| chamber\_service | SSM parameter service name for use with chamber. This is used in chamber\_format where /$chamber\_service/$parameter would be the default. | `string` | `"atlantis"` | no |
| codepipeline\_enabled | A boolean to enable/disable AWS Codepipeline and ECR | `bool` | `false` | no |
| codepipeline\_s3\_bucket\_force\_destroy | A boolean that indicates all objects should be deleted from the CodePipeline artifact store S3 bucket so that the bucket can be destroyed without error | `bool` | `false` | no |
| container\_cpu | Atlantis CPUs per task | `number` | `256` | no |
| container\_memory | Atlantis memory per task | `number` | `512` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| default\_backend\_image | ECS default (bootstrap) image | `string` | `"cloudposse/default-backend:0.1.2"` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| desired\_count | Atlantis desired number of tasks | `number` | `1` | no |
| ecs\_alarms\_cpu\_utilization\_high\_alarm\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High Alarm action | `list(string)` | `[]` | no |
| ecs\_alarms\_cpu\_utilization\_high\_ok\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High OK action | `list(string)` | `[]` | no |
| ecs\_alarms\_cpu\_utilization\_low\_alarm\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low Alarm action | `list(string)` | `[]` | no |
| ecs\_alarms\_cpu\_utilization\_low\_ok\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low OK action | `list(string)` | `[]` | no |
| ecs\_alarms\_enabled | A boolean to enable/disable CloudWatch Alarms for ECS Service metrics | `bool` | `false` | no |
| ecs\_alarms\_memory\_utilization\_high\_alarm\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High Alarm action | `list(string)` | `[]` | no |
| ecs\_alarms\_memory\_utilization\_high\_ok\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High OK action | `list(string)` | `[]` | no |
| ecs\_alarms\_memory\_utilization\_low\_alarm\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low Alarm action | `list(string)` | `[]` | no |
| ecs\_alarms\_memory\_utilization\_low\_ok\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low OK action | `list(string)` | `[]` | no |
| ecs\_cluster\_arn | ARN of the ECS cluster to deploy Atlantis | `string` | n/a | yes |
| ecs\_cluster\_name | Name of the ECS cluster to deploy Atlantis | `string` | n/a | yes |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| github\_oauth\_token | GitHub OAuth token. If not provided the token is looked up from SSM | `string` | `""` | no |
| github\_oauth\_token\_ssm\_name | SSM param name to lookup `github_oauth_token` if not provided | `string` | `""` | no |
| github\_webhooks\_token | GitHub OAuth Token with permissions to create webhooks. If not provided the token is looked up from SSM | `string` | `""` | no |
| github\_webhooks\_token\_ssm\_name | SSM param name to lookup `github_webhooks_token` if not provided | `string` | `""` | no |
| healthcheck\_path | Healthcheck path | `string` | `"/healthz"` | no |
| hostname | Atlantis URL | `string` | `""` | no |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| kms\_key\_id | KMS key ID used to encrypt SSM SecureString parameters | `string` | `""` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| launch\_type | The ECS launch type (valid options: FARGATE or EC2) | `string` | `"FARGATE"` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| overwrite\_ssm\_parameter | Whether to overwrite an existing SSM parameter | `bool` | `true` | no |
| parent\_zone\_id | The zone ID where the DNS record for the `short_name` will be written | `string` | `""` | no |
| policy\_arn | Permission to grant to atlantis server | `string` | `"arn:aws:iam::aws:policy/AdministratorAccess"` | no |
| private\_subnet\_ids | The private subnet IDs | `list(string)` | `[]` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| region | AWS Region for S3 bucket | `string` | n/a | yes |
| repo\_name | GitHub repository name of the atlantis to be built and deployed to ECS. | `string` | n/a | yes |
| repo\_owner | GitHub organization containing the Atlantis repository | `string` | n/a | yes |
| security\_group\_ids | Additional Security Group IDs to allow into ECS Service. | `list(string)` | `[]` | no |
| short\_name | Alantis short DNS name (e.g. `atlantis`) | `string` | `"atlantis"` | no |
| ssh\_private\_key\_name | Atlantis SSH private key name | `string` | `"atlantis_ssh_private_key"` | no |
| ssh\_public\_key\_name | Atlantis SSH public key name | `string` | `"atlantis_ssh_public_key"` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| vpc\_id | VPC ID for the ECS Cluster | `string` | n/a | yes |
| webhook\_enabled | Set to false to prevent the module from creating any webhook resources | `bool` | `true` | no |
| webhook\_events | A list of events which should trigger the webhook. | `list(string)` | <pre>[<br>  "issue_comment",<br>  "pull_request",<br>  "pull_request_review",<br>  "pull_request_review_comment",<br>  "push"<br>]</pre> | no |
| webhook\_secret\_length | GitHub webhook secret length | `number` | `32` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_ingress\_target\_group\_arn | ALB Target Group ARN |
| alb\_ingress\_target\_group\_arn\_suffix | ALB Target Group ARN suffix |
| alb\_ingress\_target\_group\_name | ALB Target Group name |
| atlantis\_ssh\_public\_key | Atlantis SSH Public Key |
| atlantis\_url | The URL endpoint for the atlantis server |
| atlantis\_webhook\_url | atlantis webhook URL |
| codebuild\_badge\_url | The URL of the build badge when badge\_enabled is enabled |
| codebuild\_cache\_bucket\_arn | CodeBuild cache S3 bucket ARN |
| codebuild\_cache\_bucket\_name | CodeBuild cache S3 bucket name |
| codebuild\_project\_id | CodeBuild project ID |
| codebuild\_project\_name | CodeBuild project name |
| codebuild\_role\_arn | CodeBuild IAM Role ARN |
| codebuild\_role\_id | CodeBuild IAM Role ID |
| codepipeline\_arn | CodePipeline ARN |
| codepipeline\_id | CodePipeline ID |
| codepipeline\_webhook\_id | The CodePipeline webhook's ID |
| codepipeline\_webhook\_url | The CodePipeline webhook's URL. POST events to this endpoint to trigger the target |
| container\_definition\_json | JSON encoded list of container definitions for use with other terraform resources such as aws\_ecs\_task\_definition |
| container\_definition\_json\_map | JSON encoded container definitions for use with other terraform resources such as aws\_ecs\_task\_definition |
| ecr\_registry\_id | Registry ID |
| ecr\_repository\_name | Repository name |
| ecr\_repository\_url | Repository URL |
| ecs\_alarms\_cpu\_utilization\_high\_cloudwatch\_metric\_alarm\_arn | ECS CPU utilization high CloudWatch metric alarm ARN |
| ecs\_alarms\_cpu\_utilization\_high\_cloudwatch\_metric\_alarm\_id | ECS CPU utilization high CloudWatch metric alarm ID |
| ecs\_alarms\_cpu\_utilization\_low\_cloudwatch\_metric\_alarm\_arn | ECS CPU utilization low CloudWatch metric alarm ARN |
| ecs\_alarms\_cpu\_utilization\_low\_cloudwatch\_metric\_alarm\_id | ECS CPU utilization low CloudWatch metric alarm ID |
| ecs\_alarms\_memory\_utilization\_high\_cloudwatch\_metric\_alarm\_arn | ECS Memory utilization high CloudWatch metric alarm ARN |
| ecs\_alarms\_memory\_utilization\_high\_cloudwatch\_metric\_alarm\_id | ECS Memory utilization high CloudWatch metric alarm ID |
| ecs\_alarms\_memory\_utilization\_low\_cloudwatch\_metric\_alarm\_arn | ECS Memory utilization low CloudWatch metric alarm ARN |
| ecs\_alarms\_memory\_utilization\_low\_cloudwatch\_metric\_alarm\_id | ECS Memory utilization low CloudWatch metric alarm ID |
| ecs\_cloudwatch\_autoscaling\_scale\_down\_policy\_arn | ARN of the scale down policy |
| ecs\_cloudwatch\_autoscaling\_scale\_up\_policy\_arn | ARN of the scale up policy |
| ecs\_exec\_role\_policy\_id | The ECS service role policy ID, in the form of `role_name:role_policy_name` |
| ecs\_exec\_role\_policy\_name | ECS service role name |
| ecs\_service\_name | ECS Service name |
| ecs\_service\_role\_arn | ECS Service role ARN |
| ecs\_service\_security\_group\_id | Security Group ID of the ECS task |
| ecs\_task\_definition\_family | ECS task definition family |
| ecs\_task\_definition\_revision | ECS task definition revision |
| ecs\_task\_exec\_role\_arn | ECS Task exec role ARN |
| ecs\_task\_exec\_role\_name | ECS Task role name |
| ecs\_task\_role\_arn | ECS Task role ARN |
| ecs\_task\_role\_id | ECS Task role id |
| ecs\_task\_role\_name | ECS Task role name |
| httpcode\_elb\_5xx\_count\_cloudwatch\_metric\_alarm\_arn | ALB 5xx count CloudWatch metric alarm ARN |
| httpcode\_elb\_5xx\_count\_cloudwatch\_metric\_alarm\_id | ALB 5xx count CloudWatch metric alarm ID |
| httpcode\_target\_3xx\_count\_cloudwatch\_metric\_alarm\_arn | ALB Target Group 3xx count CloudWatch metric alarm ARN |
| httpcode\_target\_3xx\_count\_cloudwatch\_metric\_alarm\_id | ALB Target Group 3xx count CloudWatch metric alarm ID |
| httpcode\_target\_4xx\_count\_cloudwatch\_metric\_alarm\_arn | ALB Target Group 4xx count CloudWatch metric alarm ARN |
| httpcode\_target\_4xx\_count\_cloudwatch\_metric\_alarm\_id | ALB Target Group 4xx count CloudWatch metric alarm ID |
| httpcode\_target\_5xx\_count\_cloudwatch\_metric\_alarm\_arn | ALB Target Group 5xx count CloudWatch metric alarm ARN |
| httpcode\_target\_5xx\_count\_cloudwatch\_metric\_alarm\_id | ALB Target Group 5xx count CloudWatch metric alarm ID |
| target\_response\_time\_average\_cloudwatch\_metric\_alarm\_arn | ALB Target Group response time average CloudWatch metric alarm ARN |
| target\_response\_time\_average\_cloudwatch\_metric\_alarm\_id | ALB Target Group response time average CloudWatch metric alarm ID |

<!-- markdownlint-restore -->
