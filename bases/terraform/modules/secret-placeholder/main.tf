# This should only be used in combination with s3 remote state with
# encryption enabled.
#
# https://www.terraform.io/docs/state/sensitive-data.html
locals {
  count = var.enabled ? 1 : 0
}

resource "aws_ssm_parameter" "secret" {
  count = local.count

  name        = "/${var.prefix}/${var.env}/${var.name}"
  type        = "SecureString"
  value       = var.placeholder

  lifecycle {
    ignore_changes = [
      value
    ]
  }

  tags = {
    Environment = var.env
    Prefix      = var.prefix
  }
}
