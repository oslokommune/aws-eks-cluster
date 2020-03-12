# FIXME: This will eventually become a fully working example.

data "aws_caller_identity" "this" {}
data "aws_iam_policy" "boundary" {
  arn = "arn:aws:iam::${local.account_id}:policy/oslokommune/oslokommune-boundary"
}

locals {
  account_id = data.aws_caller_identity.this.account_id

  env    = var.env
  prefix = var.prefix
  region = var.region
  email  = "origo@oslokommune.no"
  domain = "origo.oslo.systems"

  github_org             = "oslokommune"
  github_team            = "XXX"
  github_team_id         = "12345"
  github_url             = "git@github.com:oslokommune/origo.git"
  github_name            = "Origo"
  github_repository_slug = "origo"

  github_grafana_client_id = "XXX"
  github_argocd_client_id  = "XXX"

  echo_domain  = "echo.${local.domain}"
}

module "managed-cluster" {
  source = "../bases/terraform/modules/managed-cluster"

  domain = local.domain
  email  = local.email
  env    = local.env
  prefix = local.prefix
  region = local.region

  monitoring = {
    enabled = true

    // A grafana.monit.{domain} IRL will be created,
    // authentication will be performed via github
    // oauth
    github_authentication = {
      organisation      = local.github_org
      team_id           = local.github_team_id
      grafana_client_id = local.github_grafana_client_id
    }
  }

  deployment = {
    enabled = true
    email   = local.email

    // These are the repositories that Argo CD will
    // watch for changes to deployments
    repositories = [{
      url          = local.github_url,
      name         = local.github_name,
      repository   = local.github_repository_slug,
      organisation = local.github_org,
    }]

    // An argocd.{domain} URL will be created, and
    // authentication will be performed via github
    // oauth
    github_authentication = {
      organisation     = local.github_org,
      team             = local.github_team,
      argocd_client_id = local.github_argocd_client_id,
    }
  }

  permissions_boundary_arn = data.aws_iam_policy.boundary.arn
}

// An example application that is deployed onto the cluster
// and managed by Argo CD
module "echo" {
  source    = "../bases/terraform/modules/echo"
  domain    = local.echo_domain
  env       = local.env
  git_path  = "${local.env}/applications/echo"
  git_url   = local.github_url
  namespace = "echo"
  prefix    = local.prefix
  zone_id   = module.managed-cluster.hosted_zone_id
}

module "kuard" {
  source    = "../bases/terraform/modules/kuard"
  env       = local.env
  git_path  = "${local.env}/applications/kuard"
  git_url   = local.github_url
  namespace = "kuard"
  prefix    = local.prefix
}
