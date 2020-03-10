module "remote-state" {
  source = "git::git@github.com:oslokommune/aws-eks-cluster.git//bases/terraform/modules/remote-state"
  prefix = var.prefix
  region = var.region
  env    = var.env
}
