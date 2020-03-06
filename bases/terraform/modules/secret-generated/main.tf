# This should only be used in combination with s3 remote state with
# encryption enabled.
#
# https://www.terraform.io/docs/providers/random/r/password.html
# https://www.terraform.io/docs/state/sensitive-data.html
locals {
  count = var.enabled ? 1 : 0
}

resource "random_password" "content" {
  count   = local.count
  length  = 24
  special = false
}

resource "aws_ssm_parameter" "secret" {
  count = local.count

  name  = "/${var.prefix}/${var.env}/${var.name}"
  type  = "SecureString"
  value = random_password.content[count.index].result

  tags = {
    Environment = var.env
    Prefix      = var.prefix
  }
}
