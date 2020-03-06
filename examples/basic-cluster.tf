# FIXME: This will eventually become a fully working example.

data "aws_caller_identity" "this" {}
data "aws_iam_policy" "boundary" {
  arn = "arn:aws:iam::${local.account_id}:policy/oslokommune/oslokommune-boundary"
}

locals {
  account_id = data.aws_caller_identity.this.account_id

  domain = "origo-dev.oslo.systems"
  email  = "origo@oslo.kommune.no"

  github_org  = "oslokommune"
  github_team = "origo"

  db_name     = "db"
  db_database = "origo"
  db_admin    = "origo_admin"
  db_domain   = "${local.db_name}.${local.domain}"

  backend_name   = "backend"
  backend_domain = "${local.backend_name}.${local.domain}"

  frontend_name   = "frontend"
  frontend_domain = "${local.frontend_name}.${local.domain}"
}

module "managed-cluster" {
  source = "../bases/terraform/modules/managed-cluster"

  domain = local.domain
  email  = local.email
  env    = var.env
  prefix = var.prefix
  region = var.region

  monitoring = {
    enabled = true

    # A grafana client integration needs to be created
    # FIXME: Add to this example what the callback URL
    # should look like
    github_authentication = {
      organisation      = local.github_org
      team              = local.github_team
      grafana_client_id = "XXX"
    }
  }

  deployment = {
    enabled = true
    email   = local.email

    repositories = [{
      url          = "git@github.com:oslokommune/origo.git",
      name         = "Origo",
      repository   = "origo",
      organisation = local.github_org,
    }]

    # FIXME: Add to this example what the callback URL
    # should look like
    github_authentication = {
      organisation     = local.github_org
      team             = local.github_team
      argocd_client_id = "XXX"
    }
  }

  permissions_boundary_arn = data.aws_iam_policy.boundary.arn
}

module "postgres" {
  source                         = "../bases/terraform/modules/eks-postgres"
  admin_username                 = local.db_admin
  application                    = "backend"
  application_configuration_path = "../applications"
  cluster_name                   = module.managed-cluster.cluster_name
  db_name                        = local.db_database
  dns_name                       = local.db_domain
  env                            = var.env
  hosted_zone_id                 = module.managed-cluster.hosted_zone_id
  prefix                         = var.prefix
  region                         = var.region
  subnets                        = module.managed-cluster.database_subnets
  subnets_cidrs                  = module.managed-cluster.database_subnets_cidrs
  vpc_id                         = module.managed-cluster.vpc_id
  permissions_boundary_arn       = data.aws_iam_policy.boundary.arn
  namespace                      = "origo-backend"
}

