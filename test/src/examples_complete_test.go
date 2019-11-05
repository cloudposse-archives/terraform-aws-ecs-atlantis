package test

import (
	"encoding/json"
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	targets := []string{"module.label", "module.vpc", "module.subnets", "module.alb"}

	// We need to create the ALB first because terraform does not wwait for it to be in the ready state before creating ECS target group
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		Targets:  targets,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer func() {
		if r := recover(); r != nil {
			terraformOptions.Targets = targets
			terraform.Destroy(t, terraformOptions)
			terraformOptions.Targets = nil
			terraform.Destroy(t, terraformOptions)
			assert.Fail(t, fmt.Sprintf("Panicked: %v", r))
		} else {
			terraformOptions.Targets = nil
			terraform.Destroy(t, terraformOptions)
		}
	}()

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	terraformOptions.Targets = nil

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	vpcCidr := terraform.Output(t, terraformOptions, "vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.16.0.0/16", vpcCidr)

	// Run `terraform output` to get the value of an output variable
	privateSubnetCidrs := terraform.OutputList(t, terraformOptions, "private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.0.0/19", "172.16.32.0/19"}, privateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	publicSubnetCidrs := terraform.OutputList(t, terraformOptions, "public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.96.0/19", "172.16.128.0/19"}, publicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	albName := terraform.Output(t, terraformOptions, "alb_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis", albName)

	// Run `terraform output` to get the value of an output variable
	albHttpListenerArn := terraform.Output(t, terraformOptions, "alb_http_listener_arn")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, albHttpListenerArn, "listener/app/eg-test-ecs-atlantis")

	// Run `terraform output` to get the value of an output variable
	albIngressTargetGroupName := terraform.Output(t, terraformOptions, "alb_ingress_target_group_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis", albIngressTargetGroupName)

	// Run `terraform output` to get the value of an output variable
	albAccessLogsBucketId := terraform.Output(t, terraformOptions, "alb_access_logs_bucket_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-alb-access-logs", albAccessLogsBucketId)

	// Run `terraform output` to get the value of an output variable
	containerDefinitionJsonMap := terraform.OutputRequired(t, terraformOptions, "container_definition_json_map")
	// Verify we're getting back the outputs we expect
	var jsonObject map[string]interface{}
	err := json.Unmarshal([]byte(containerDefinitionJsonMap), &jsonObject)
	assert.NoError(t, err)
	assert.Equal(t, "eg-test-ecs-atlantis", jsonObject["name"])
	assert.Equal(t, "cloudposse/default-backend:0.1.2", jsonObject["image"])
	assert.Equal(t, 512, int((jsonObject["memory"]).(float64)))
	assert.Equal(t, 128, int((jsonObject["memoryReservation"]).(float64)))
	assert.Equal(t, 256, int((jsonObject["cpu"]).(float64)))
	assert.Equal(t, true, jsonObject["essential"])
	assert.Equal(t, false, jsonObject["readonlyRootFilesystem"])

	// Run `terraform output` to get the value of an output variable
	codebuildCacheBucketName := terraform.Output(t, terraformOptions, "codebuild_cache_bucket_name")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, codebuildCacheBucketName, "eg-test-ecs-atlantis-build")

	// Run `terraform output` to get the value of an output variable
	codebuildProjectName := terraform.Output(t, terraformOptions, "codebuild_project_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-build", codebuildProjectName)

	// Run `terraform output` to get the value of an output variable
	codebuildRoleId := terraform.Output(t, terraformOptions, "codebuild_role_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-build", codebuildRoleId)

	// Run `terraform output` to get the value of an output variable
	codepipelineId := terraform.Output(t, terraformOptions, "codepipeline_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-codepipeline", codepipelineId)

	// Run `terraform output` to get the value of an output variable
	ecrRepositoryName := terraform.Output(t, terraformOptions, "ecr_repository_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-ecr", ecrRepositoryName)

	// Run `terraform output` to get the value of an output variable
	ecsTaskRoleName := terraform.Output(t, terraformOptions, "ecs_task_role_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-task", ecsTaskRoleName)

	// Run `terraform output` to get the value of an output variable
	ecsTaskExecRoleName := terraform.Output(t, terraformOptions, "ecs_task_exec_role_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-exec", ecsTaskExecRoleName)

	// Run `terraform output` to get the value of an output variable
	ecsServiceName := terraform.Output(t, terraformOptions, "ecs_service_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis", ecsServiceName)

	// Run `terraform output` to get the value of an output variable
	ecsExecRolePolicyName := terraform.Output(t, terraformOptions, "ecs_exec_role_policy_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-exec", ecsExecRolePolicyName)

	// Run `terraform output` to get the value of an output variable
	ecsCloudwatchAutoscalingScaleDownPolicyArn := terraform.Output(t, terraformOptions, "ecs_cloudwatch_autoscaling_scale_down_policy_arn")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, ecsCloudwatchAutoscalingScaleDownPolicyArn, "policyName/eg-test-ecs-atlantis-down")

	// Run `terraform output` to get the value of an output variable
	ecsCloudwatchAutoscalingScaleUpPolicyArn := terraform.Output(t, terraformOptions, "ecs_cloudwatch_autoscaling_scale_up_policy_arn")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, ecsCloudwatchAutoscalingScaleUpPolicyArn, "policyName/eg-test-ecs-atlantis-up")

	// Run `terraform output` to get the value of an output variable
	ecsAlarmsCpuUtilizationHighCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "ecs_alarms_cpu_utilization_high_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-cpu-utilization-high", ecsAlarmsCpuUtilizationHighCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	ecsAlarmsCpuUtilizationLowCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "ecs_alarms_cpu_utilization_low_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-cpu-utilization-low", ecsAlarmsCpuUtilizationLowCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	ecsAlarmsMemoryUtilizationHighCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "ecs_alarms_memory_utilization_high_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-memory-utilization-high", ecsAlarmsMemoryUtilizationHighCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	ecsAlarmsMemoryUtilizationLowCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "ecs_alarms_memory_utilization_low_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-memory-utilization-low", ecsAlarmsMemoryUtilizationLowCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	httpcodeElb5xxCountCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "httpcode_elb_5xx_count_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-elb-5xx-count-high", httpcodeElb5xxCountCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	httpcodeTarget3xxCountCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "httpcode_target_3xx_count_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-3xx-count-high", httpcodeTarget3xxCountCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	httpcodeTarget4xxCountCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "httpcode_target_4xx_count_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-4xx-count-high", httpcodeTarget4xxCountCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	httpcodeTarget5xxCountCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "httpcode_target_5xx_count_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-5xx-count-high", httpcodeTarget5xxCountCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	targetResponseTimeAverageCloudwatchMetricAlarmId := terraform.Output(t, terraformOptions, "target_response_time_average_cloudwatch_metric_alarm_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-atlantis-target-response-high", targetResponseTimeAverageCloudwatchMetricAlarmId)

	// Run `terraform output` to get the value of an output variable
	atlantisUrl := terraform.Output(t, terraformOptions, "atlantis_url")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "https://ecs-atlantis-test.testing.cloudposse.co", atlantisUrl)

	// Run `terraform output` to get the value of an output variable
	atlantisWebhookUrl := terraform.Output(t, terraformOptions, "atlantis_webhook_url")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "https://ecs-atlantis-test.testing.cloudposse.co/events", atlantisWebhookUrl)
}
