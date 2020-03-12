locals {
  base_dir = "${var.application_configuration_path}/kuard"
}

resource "local_file" "kustomization" {
  filename = "${local.base_dir}/kustomization.yml"
  content = templatefile("${path.module}/templates/kustomization.tmpl", {
    bases_configuration_path = var.bases_configuration_path,
    namespace = var.namespace
  })
}

resource "local_file" "patch_ingress" {
  filename = "${local.base_dir}/patch_ingress.json"
  content = templatefile("${path.module}/templates/patch_ingress.json", {
    host      = var.domain,
    host_cert = module.cert.arn,
  })
}

resource "local_file" "patch_configmap" {
  filename = "${local.base_dir}/patch_configmap.json"
  content = templatefile("${path.module}/templates/patch_configmap.json", {
    env = var.env
  })
}

resource "local_file" "argocd-application" {
  filename = "${local.base_dir}/application.yml"
  content = templatefile("${path.module}/templates/application.yml", {
    namespace = var.namespace
    path = var.git_path
    url = var.git_url
  })
}

resource "local_file" "deployment" {
  filename = "${local.base_dir}/deployment.yml"
  content = templatefile("${path.module}/templates/deployment.yml", {
    image_url = "${aws_ecr_repository.kuard.repository_url}:latest"
  })
}

resource "local_file" "makefile" {
  filename = "${local.base_dir}/Makefile"
  content  = file("${path.module}/templates/Makefile")
}
