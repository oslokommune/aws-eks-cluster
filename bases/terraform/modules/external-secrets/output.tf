locals {
  base_dir = "${var.cluster_configuration_path}/external-secrets"
}

resource "local_file" "service_account" {
  count    = local.count
  filename = "${local.base_dir}/service_account.yml"
  content = templatefile("${path.module}/templates/serviceaccount.tmpl", {
    env                  = var.env,
    prefix               = var.prefix,
    region               = var.region,
    cluster_name         = var.cluster_name,
    permissions_boundary = var.permissions_boundary_arn,
    policy_arn           = aws_iam_policy.policy[count.index].arn,
  })
}

resource "local_file" "values" {
  count    = local.count
  filename = "${local.base_dir}/values.yml"
  content = templatefile("${path.module}/templates/values.tmpl", {
    region = var.region
  })
}

resource "local_file" "makefile" {
  count    = local.count
  filename = "${local.base_dir}/Makefile"
  content  = file("${path.module}/templates/Makefile")
}
