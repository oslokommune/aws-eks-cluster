module "remote-state" {
  source = "../../../bases/terraform/modules/remote-state"
  prefix = var.prefix
  region = var.region
  env    = var.env
}
