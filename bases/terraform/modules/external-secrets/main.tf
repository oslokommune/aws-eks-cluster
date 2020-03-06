data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

locals {
  count = var.enabled ? 1 : 0
  account = data.aws_caller_identity.this.account_id
  region = data.aws_region.this.name
}

resource "aws_iam_policy" "policy" {
  count  = local.count
  name   = "${var.prefix}-${var.env}-ExternalSecretsServiceAccountPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ssm:GetParameter",
      "Resource": "arn:aws:ssm:${local.region}:${local.account}:parameter/*"
    }
  ]
}
EOF
}