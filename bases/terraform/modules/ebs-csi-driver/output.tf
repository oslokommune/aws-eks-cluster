locals {
  base_dir = "${var.cluster_configuration_path}/ebs-csi-driver"
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

resource "local_file" "kustomization" {
  count    = local.count
  filename = "${local.base_dir}/kustomization.yml"
  content = templatefile("${path.module}/templates/kustomization.tmpl", {
    bases_configuration_path = var.bases_configuration_path,
  })
}

resource "local_file" "storageclass" {
  count    = local.count
  filename = "${local.base_dir}/storageclass.yml"
  content  = file("${path.module}/templates/storageclass.tmpl")
}

resource "local_file" "makefile" {
  count    = local.count
  filename = "${local.base_dir}/Makefile"
  content  = file("${path.module}/templates/Makefile")
}
