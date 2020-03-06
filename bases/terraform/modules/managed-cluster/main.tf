data "aws_availability_zones" "available" {}
data "aws_region" "this" {}
data "aws_route53_zone" "primary" {
  name = var.domain
}

locals {
  cluster_name = "${var.prefix}-cluster-${var.env}"

  # Ensure that certain dependencies are always made available
  enable_external_secrets       = var.enable_external_secrets || var.monitoring.enabled || var.deployment.enabled
  enable_external_dns           = var.enable_external_dns || var.monitoring.enabled || var.deployment.enabled
  enable_alb_ingress_controller = var.enable_alb_ingress_controller || var.monitoring.enabled || var.deployment.enabled
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "${var.prefix}-${var.env}"
  vpc_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared",
  }

  # Docker runs in the 172.17.0.0/16 CIDR range in Amazon EKS clusters
  # Do not use this range.
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets_cidrs
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"             = 1,
    "kubernetes.io/cluster/${local.cluster_name}" = "shared",
  }

  public_subnets = var.public_subnets_cidrs
  public_subnet_tags = {
    "kubernetes.io/role/elb"                      = 1,
    "kubernetes.io/cluster/${local.cluster_name}" = "shared",
  }

  database_subnets = var.database_subnets_cidrs

  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  enable_nat_gateway = "true"

  tags = {
    Environment = var.env
    Prefix      = var.prefix
  }
}

module "cluster" {
  source                          = "../cluster"
  bases_configuration_path        = var.bases_configuration_path
  cluster_configuration_path      = var.cluster_configuration_path
  cluster_name                    = local.cluster_name
  env                             = var.env
  permissions_boundary_arn        = var.permissions_boundary_arn
  prefix                          = var.prefix
  region                          = var.region
  availability_zones              = module.vpc.azs
  vpc_cidr_block                  = module.vpc.vpc_cidr_block
  vpc_id                          = module.vpc.vpc_id
  vpc_private_subnets             = module.vpc.private_subnets
  vpc_private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  vpc_public_subnets              = module.vpc.public_subnets
  vpc_public_subnets_cidr_blocks  = module.vpc.public_subnets_cidr_blocks
}

module "alb_ingress_controller" {
  source                     = "../alb-ingress-controller"
  enabled                    = local.enable_alb_ingress_controller
  bases_configuration_path   = var.bases_configuration_path
  cluster_configuration_path = var.cluster_configuration_path
  cluster_name               = local.cluster_name
  env                        = var.env
  permissions_boundary_arn   = var.permissions_boundary_arn
  prefix                     = var.prefix
  region                     = var.region
  vpc_id                     = module.vpc.vpc_id
}

module "autoscaler" {
  source                     = "../autoscaler"
  enabled                    = var.enable_autoscaler
  bases_configuration_path   = var.bases_configuration_path
  cluster_configuration_path = var.cluster_configuration_path
  cluster_name               = local.cluster_name
  env                        = var.env
  permissions_boundary_arn   = var.permissions_boundary_arn
  prefix                     = var.prefix
  region                     = var.region
}

module "ebs_csi_driver" {
  source                     = "../ebs-csi-driver"
  enabled                    = var.enable_ebs_csi_driver
  bases_configuration_path   = var.bases_configuration_path
  cluster_configuration_path = var.cluster_configuration_path
  cluster_name               = local.cluster_name
  env                        = var.env
  permissions_boundary_arn   = var.permissions_boundary_arn
  prefix                     = var.prefix
  region                     = var.region
}

module "external_dns" {
  source                     = "../external-dns"
  enabled                    = local.enable_external_dns
  bases_configuration_path   = var.bases_configuration_path
  cluster_configuration_path = var.cluster_configuration_path
  cluster_name               = local.cluster_name
  env                        = var.env
  permissions_boundary_arn   = var.permissions_boundary_arn
  prefix                     = var.prefix
  region                     = var.region
  domain_filter              = var.domain
  hosted_zone_id             = data.aws_route53_zone.primary.id
}

module "external_secrets" {
  source                     = "../external-secrets"
  enabled                    = local.enable_external_secrets
  cluster_configuration_path = var.cluster_configuration_path
  cluster_name               = local.cluster_name
  env                        = var.env
  permissions_boundary_arn   = var.permissions_boundary_arn
  prefix                     = var.prefix
  region                     = var.region
}

module "ecr_power_user" {
  source                     = "../ecr-power-user"
  enabled                    = var.enable_ecr_power_user
  cluster_configuration_path = var.cluster_configuration_path
  cluster_name               = local.cluster_name
  env                        = var.env
  permissions_boundary_arn   = var.permissions_boundary_arn
  prefix                     = var.prefix
  region                     = var.region
}

module "nodegroup_generic" {
  source                     = "../nodegroups-generic"
  enabled                    = var.enable_nodegroup_generic
  cluster_configuration_path = var.cluster_configuration_path
  cluster_name               = local.cluster_name
  env                        = var.env
  permissions_boundary_arn   = var.permissions_boundary_arn
  prefix                     = var.prefix
  region                     = var.region
}

module "prometheus_operator" {
  source                     = "../prometheus-operator"
  enabled                    = var.monitoring.enabled
  bases_configuration_path   = var.bases_configuration_path
  cluster_configuration_path = var.cluster_configuration_path
  cluster_name               = local.cluster_name
  env                        = var.env
  permissions_boundary_arn   = var.permissions_boundary_arn
  prefix                     = var.prefix
  region                     = var.region
  domain                     = var.domain
  zone_id                    = data.aws_route53_zone.primary.id
  github_authentication      = var.monitoring.github_authentication
}

module "loki" {
  source                     = "../loki"
  enabled                    = var.monitoring.enabled
  bases_configuration_path   = var.bases_configuration_path
  cluster_configuration_path = var.cluster_configuration_path
  env                        = var.env
  prefix                     = var.prefix
}

module "argocd" {
  source                     = "../argocd"
  enabled                    = var.deployment.enabled
  cluster_configuration_path = var.cluster_configuration_path
  env                        = var.env
  prefix                     = var.prefix
  domain                     = var.domain
  zone_id                    = data.aws_route53_zone.primary.id
  github_authentication      = var.deployment.github_authentication
  repositories               = var.deployment.repositories
  email                      = var.email
}