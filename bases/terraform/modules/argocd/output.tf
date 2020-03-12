locals {
  base_dir = "${var.cluster_configuration_path}/argocd"
}

resource "local_file" "kustomization" {
  count    = local.count
  filename = "${local.base_dir}/kustomization.yml"
  content = templatefile("${path.module}/templates/kustomization.tmpl", {
  })
}

resource "local_file" "namespace" {
  count    = local.count
  filename = "${local.base_dir}/namespace.yml"
  content  = file("${path.module}/templates/namespace.tmpl")
}

resource "local_file" "makefile" {
  count    = local.count
  filename = "${local.base_dir}/Makefile"
  content = templatefile("${path.module}/templates/Makefile", {
    parameters = module.client_secret.name,
    public_key = tls_private_key.key.public_key_openssh,
    email      = var.email,
    repos      = var.repositories,
  })
}

resource "local_file" "argo-cd-cm" {
  count    = local.count
  filename = "${local.base_dir}/argo-cd-cm.yaml"
  content = templatefile("${path.module}/templates/argo-cd-cm.yaml", {
    domain    = local.domain_argocd,
    client_id = var.github_authentication.argocd_client_id,
    org       = var.github_authentication.organisation,
    team      = var.github_authentication.team,
    repos     = var.repositories,
  })
}

resource "local_file" "argo-cd-dashboard" {
  count = local.count
  filename = "${local.base_dir}/argo-cd-grafana-dashboard.yaml"
  content = templatefile("${path.module}/templates/argo-cd-grafana-dashboard.yaml", {
  })
}

resource "local_file" "argo-cd-monitoring" {
  count = local.count
  filename = "${local.base_dir}/argo-cd-monitoring.yaml"
  content = templatefile("${path.module}/templates/argo-cd-monitoring.yaml", {
  })
}

resource "local_file" "argo-cd-ingress" {
  count    = local.count
  filename = "${local.base_dir}/argo-cd-ingress.yaml"
  content = templatefile("${path.module}/templates/argo-cd-ingress.yaml", {
    cert_arn = module.cert.arn,
    domain   = local.domain_argocd,
  })
}

resource "local_file" "argo-cd-server-patch" {
  count    = local.count
  filename = "${local.base_dir}/argo-cd-server-patch.json"
  content = templatefile("${path.module}/templates/argo-cd-server-patch.json", {
  })
}

resource "local_file" "argo-cd-server-service" {
  count    = local.count
  filename = "${local.base_dir}/argo-cd-server-service.yml"
  content = templatefile("${path.module}/templates/argo-cd-server-service.yml", {
  })
}

resource "local_file" "argo-cd-rbac" {
  count    = local.count
  filename = "${local.base_dir}/argo-cd-rbac-cm.yaml"
  content = templatefile("${path.module}/templates/argo-cd-rbac-cm.yaml", {
    org  = var.github_authentication.organisation,
    team = var.github_authentication.team,
  })
}

resource "local_file" "argo-cd-secret" {
  filename = "${local.base_dir}/argo-cd-secret-external.yml"
  content = templatefile("${path.module}/templates/argo-cd-secret-external.yml", {
    name = "argocd-secret"
    data = {
      "admin.password"          = module.admin_secret.name,
      "admin.passwordMtime"     = module.admin_mtime.name,
      "dex.github.clientSecret" = module.client_secret.name,
      "server.secretkey"        = module.server_secret_key.name,
    }
  })
}

resource "local_file" "argo-cd-privatekey" {
  filename = "${local.base_dir}/argo-cd-privatekey-external.yml"
  content = templatefile("${path.module}/templates/argo-cd-privatekey-external.yml", {
    name = "argocd-privatekey"
    data = {
      sshPrivateKey = module.git_priv_key.name,
    }
  })
}
