module "cert" {
  source  = "git::git@github.com:oslokommune/aws-eks-cluster.git//bases/terraform/modules/certificate"
  domain  = var.domain
  env     = var.env
  prefix  = var.prefix
  zone_id = var.zone_id
}

resource "aws_ecr_repository" "echo" {
  name = "echo/echo"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.env
    Prefix      = var.prefix
  }
}
