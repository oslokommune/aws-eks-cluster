locals {
  base_dir = "${var.application_configuration_path}/postgres-${var.application}"
}

resource "local_file" "nodegroup" {
  filename = "${local.base_dir}/node_group.yml"
  content = templatefile("${path.module}/templates/node_group.tmpl", {
    env                  = var.env,
    prefix               = var.prefix,
    application          = var.application,
    region               = var.region,
    cluster_name         = var.cluster_name,
    permissions_boundary = var.permissions_boundary_arn,
    security_groups      = [aws_security_group.postgres.id],
    instance_type        = var.instance_type,
    desired_capacity     = var.desired_capacity,
    autoscaling          = var.autoscaling,
    max_capacity         = var.max_capacity,
  })
}

resource "local_file" "secrets" {
  filename = "${local.base_dir}/external_secrets.yml"
  content = templatefile("${path.module}/templates/externalsecrets.tmpl", {
    application = var.application
    admin_key   = module.admin.name
    user_key    = module.user.name
  })
}

resource "local_file" "service" {
  filename = "${local.base_dir}/external_service.yml"
  content = templatefile("${path.module}/templates/externalservice.tmpl", {
    application = var.application
    dns_name    = aws_route53_record.alias.fqdn
  })
}

resource "local_file" "makefile" {
  filename = "${local.base_dir}/Makefile"
  content = templatefile("${path.module}/templates/Makefile", {
    namespace = var.namespace,
    manifests = join(" ", [
      "external_secrets.yml",
      "external_service.yml"
    ]),
  })
}
