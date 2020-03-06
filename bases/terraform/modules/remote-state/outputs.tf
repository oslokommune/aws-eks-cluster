locals {
  bucket           = aws_s3_bucket.state.bucket
  bucket-key       = "terraform/${var.prefix}/terraform.tfstate"
  lock             = aws_dynamodb_table.lock.name
  backend-filename = "${var.prefix}-backend-conf-${var.env}.hcl"
}

output "tf-remote-state-bucket" {
  value = local.bucket
}

output "tf-remote-state-bucket-key" {
  value = local.bucket-key
}

output "tf-remote-state-lock" {
  value = local.lock
}

output "tf-remote-state-backend-file" {
  value = local.backend-filename
}

resource "local_file" "shared-backend" {
  filename = local.backend-filename

  content = <<CONTENT
bucket = "${local.bucket}"
key = "${local.bucket-key}"
region = "${var.region}"
dynamodb_table = "${local.lock}"
  
CONTENT

}

