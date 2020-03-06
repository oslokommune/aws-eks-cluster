locals {
  base_dir = "${var.cluster_configuration_path}/external-dns"
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

resource "local_file" "config_map_patch" {
  count    = local.count
  filename = "${local.base_dir}/config_map.yml"
  content = templatefile("${path.module}/templates/config_map_patch.tmpl", {
    hosted_zone_id = var.hosted_zone_id,
    domain_filter  = var.domain_filter,
  })
}

resource "local_file" "makefile" {
  count    = local.count
  filename = "${local.base_dir}/Makefile"
  content  = file("${path.module}/templates/Makefile")
}
