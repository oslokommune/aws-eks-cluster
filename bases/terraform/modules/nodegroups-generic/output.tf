locals {
  base_dir = "${var.cluster_configuration_path}/ng-generic"
}

resource "local_file" "nodegroup" {
  count    = local.count
  filename = "${local.base_dir}/node_group.yml"
  content = templatefile("${path.module}/templates/nodegroup_generic.tmpl", {
    env                  = var.env,
    prefix               = var.prefix,
    region               = var.region,
    cluster_name         = var.cluster_name,
    permissions_boundary = var.permissions_boundary_arn,
    instance_type        = var.instance_type
    desired_capacity     = var.desired_capacity
    autoscaling          = var.autoscaling
    max_capacity         = var.max_capacity
  })
}

resource "local_file" "makefile" {
  count    = local.count
  filename = "${local.base_dir}/Makefile"
  content  = file("${path.module}/templates/Makefile")
}
