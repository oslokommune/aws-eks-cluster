locals {
  count = var.enabled ? 1 : 0

  domain_argocd = "argocd.${var.domain}"
}

module "cert" {
  source  = "git::git@github.com:oslokommune/aws-eks-cluster.git//bases/terraform/modules/certificate"
  enabled = var.enabled
  env     = var.env
  prefix  = var.prefix
  domain  = local.domain_argocd
  zone_id = var.zone_id
}

resource "random_password" "admin_pass" {
  length  = 16
  special = true
}

module "admin_secret" {
  source      = "git::git@github.com:oslokommune/aws-eks-cluster.git//bases/terraform/modules/secret-placeholder"
  enabled     = var.enabled
  env         = var.env
  prefix      = var.prefix
  name        = "deployment/argocd/admin_secret"
  placeholder = bcrypt(random_password.admin_pass.result)
}

module "admin_mtime" {
  source      = "git::git@github.com:oslokommune/aws-eks-cluster.git//bases/terraform/modules/secret-placeholder"
  enabled     = var.enabled
  env         = var.env
  prefix      = var.prefix
  name        = "deployment/argocd/admin_mtime"
  placeholder = "2020-02-27T10:02:44CET"
}

module "server_secret_key" {
  source  = "git::git@github.com:oslokommune/aws-eks-cluster.git//bases/terraform/modules/secret-generated"
  enabled = var.enabled
  env     = var.env
  prefix  = var.prefix
  name    = "deployment/argocd/server_secret_key"
}

module "client_secret" {
  source  = "git::git@github.com:oslokommune/aws-eks-cluster.git//bases/terraform/modules/secret-placeholder"
  enabled = var.enabled
  env     = var.env
  prefix  = var.prefix
  name    = "deployment/argocd/client_secret"
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "git_priv_key" {
  source      = "git::git@github.com:oslokommune/aws-eks-cluster.git//bases/terraform/modules/secret-placeholder"
  enabled     = var.enabled
  env         = var.env
  prefix      = var.prefix
  name        = "deployment/argocd/git_priv_key"
  placeholder = tls_private_key.key.private_key_pem
}
