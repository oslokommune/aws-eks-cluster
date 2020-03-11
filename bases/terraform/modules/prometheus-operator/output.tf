locals {
  base_dir = "${var.cluster_configuration_path}/prometheus-operator"
}

resource "local_file" "helm_values" {
  count    = local.count
  filename = "${local.base_dir}/values.yml"
  content = templatefile("${path.module}/templates/values.tmpl", {
    auth_secrets_name = local.auth_secrets_name
    github_org        = var.github_authentication.organisation
    github_team_id    = var.github_authentication.team_id
    domain_grafana    = local.domain_grafana
    cert_grafana_arn  = module.grafana_cert.arn
    client_id_grafana = var.github_authentication.grafana_client_id
    server_root_url = "https://${local.domain_grafana}"
  })
}

resource "local_file" "secrets" {
  filename = "${local.base_dir}/external_secrets.yml"
  content = templatefile("${path.module}/templates/externalsecrets.tmpl", {
    name = local.auth_secrets_name
    data = {
      grafana_client_secret = module.grafana_client_secret.name
      grafana_cookie_secret = module.grafana_cookie_secret.name
      grafana_admin_user    = module.grafana_admin_user.name
      grafana_admin_secret  = module.grafana_admin_secret.name
    }
  })
}

resource "local_file" "namespace" {
  filename = "${local.base_dir}/namespace.yml"
  content  = file("${path.module}/templates/namespace.tmpl")
}

resource "local_file" "makefile" {
  filename = "${local.base_dir}/Makefile"
  content = templatefile("${path.module}/templates/Makefile", {
    region  = var.region
    profile = var.profile
    parameters = join(" ", [
      module.grafana_client_secret.name,
    ]),
    manifests = join(" ", [
      "namespace.yml",
      "external_secrets.yml",
    ]),
  })
}
