module "ssh_key_pair" {
  source               = "git::https://github.com/cloudposse/terraform-aws-ssm-tls-ssh-key-pair.git?ref=tags/0.2.0"
  enabled              = "${var.enabled}"
  namespace            = "${var.namespace}"
  stage                = "${var.stage}"
  name                 = "${var.name}"
  attributes           = "${local.attributes}"
  ssh_private_key_name = "${var.ssh_private_key_name}"
  ssh_public_key_name  = "${var.ssh_public_key_name}"
  ssm_path_prefix      = "${var.chamber_service}"
}
