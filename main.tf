terraform {
  required_version = ">= 0.10.7"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "${module.default_label.id}"
  tags = "${module.default_label.tags}"
}
