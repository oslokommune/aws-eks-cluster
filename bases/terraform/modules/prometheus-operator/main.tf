locals {
  count = var.enabled ? 1 : 0

  auth_secrets_name = "${var.prefix}-monitoring-auth"
  domain_grafana      = "grafana.monit.${var.domain}"
}

module "grafana_cert" {
  source  = "../certificate"
  enabled = var.enabled
  env     = var.env
  prefix  = var.prefix
  domain  = local.domain_grafana
  zone_id = var.zone_id
}

module "grafana_client_secret" {
  source  = "../secret-placeholder"
  enabled = var.enabled
  env     = var.env
  prefix  = var.prefix
  name    = "monitoring/grafana/client_secret"
}

module "grafana_cookie_secret" {
  source  = "../secret-generated"
  enabled = var.enabled
  env     = var.env
  prefix  = var.prefix
  name    = "monitoring/grafana/cookie_secret"
}

module "grafana_admin_user" {
  source      = "../secret-placeholder"
  enabled     = var.enabled
  env         = var.env
  prefix      = var.prefix
  name        = "monitoring/grafana/admin_user"
  placeholder = "admin"
}

module "grafana_admin_secret" {
  source  = "../secret-generated"
  enabled = var.enabled
  env     = var.env
  prefix  = var.prefix
  name    = "monitoring/grafana/admin_secret"
}
