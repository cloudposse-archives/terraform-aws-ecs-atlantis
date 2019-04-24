module "ecr" {
  enabled    = "${var.codepipeline_enabled}"
  source     = "git::https://github.com/cloudposse/terraform-aws-ecr.git?ref=tags/0.5.0"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  attributes = "${compact(concat(var.attributes, list("ecr")))}"
}
