locals {
  base_dir = var.cluster_configuration_path

  cluster = "cluster"

  nodegroups = compact([
    var.enable_nodegroup_generic ? "ng-generic" : "",
  ])

  extensions = compact([
    var.enable_alb_ingress_controller ? "alb-ingress-controller" : "",
    var.enable_autoscaler ? "autoscaler" : "",
    var.enable_ebs_csi_driver ? "ebs-csi-driver" : "",
    var.enable_ecr_power_user ? "ecr-power-user" : "",
    var.enable_external_dns ? "external-dns" : "",
    var.enable_external_secrets ? "external-secrets" : "",
    var.deployment.enabled ? "argocd" : "",
    var.monitoring.enabled ? "prometheus-operator" : "",
    var.monitoring.enabled ? "loki" : "",
  ])
}

resource "template_dir" "common" {
  destination_dir = "${var.common_configuration_path}/common"
  source_dir      = "${path.module}/templates/common"
}

resource "local_file" "makefile" {
  filename = "${local.base_dir}/Makefile"
  content = templatefile("${path.module}/templates/Makefile", {
    cluster     = local.cluster
    node_groups = join(" ", local.nodegroups)
    extensions  = join(" ", local.extensions)
  })
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "database_subnets_cidrs" {
  value = module.vpc.database_subnets_cidr_blocks
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.primary.id
}

output "cluster_configuration_path" {
  value = var.cluster_configuration_path
}

output "cluster_name" {
  value = local.cluster_name
}