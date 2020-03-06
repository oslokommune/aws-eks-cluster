locals {
  base_dir = "${var.cluster_configuration_path}/cluster"
}

resource "local_file" "cluster" {
  filename = "${local.base_dir}/cluster.yml"
  content = templatefile("${path.module}/templates/cluster.tmpl", {
    env                  = var.env,
    prefix               = var.prefix,
    region               = var.region,
    cluster_name         = var.cluster_name,
    vpc_id               = var.vpc_id,
    azs                  = var.availability_zones,
    cidr                 = var.vpc_cidr_block,
    private_subnets      = var.vpc_private_subnets,
    private_subnet_cidrs = var.vpc_private_subnets_cidr_blocks,
    public_subnets       = var.vpc_public_subnets,
    public_subnet_cidrs  = var.vpc_public_subnets_cidr_blocks,
    permissions_boundary = var.permissions_boundary_arn,
  })
}

resource "local_file" "makefile" {
  filename = "${local.base_dir}/Makefile"
  content = templatefile("${path.module}/templates/Makefile", {
    region       = var.region,
    cluster_name = var.cluster_name,
  })
}
