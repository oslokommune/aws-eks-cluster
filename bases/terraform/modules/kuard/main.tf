resource "aws_ecr_repository" "kuard" {
  name = "kuard/kuard"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.env
    Prefix      = var.prefix
  }
}
