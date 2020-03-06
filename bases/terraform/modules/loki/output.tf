locals {
  base_dir = "${var.cluster_configuration_path}/loki"
}

resource "local_file" "datasource" {
  count    = local.count
  filename = "${local.base_dir}/datasource.yml"
  content  = file("${path.module}/templates/datasource.tmpl")
}

resource "local_file" "values" {
  count    = local.count
  filename = "${local.base_dir}/values.yml"
  content  = file("${path.module}/templates/values.tmpl")
}

resource "local_file" "makefile" {
  count    = local.count
  filename = "${local.base_dir}/Makefile"
  content  = file("${path.module}/templates/Makefile")
}
