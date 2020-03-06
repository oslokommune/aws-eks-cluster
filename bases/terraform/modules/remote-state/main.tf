// stores a log of all terraform actions that
// have been performed
resource "aws_s3_bucket" "log" {
  bucket = "${var.prefix}-tf-state-log-${var.env}"
  acl    = "log-delivery-write"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Description = "Terraform state storage log bucket"
    Environment = var.env
    Prefix      = var.prefix
  }
}

// stores all shared state
resource "aws_s3_bucket" "state" {
  bucket = "${var.prefix}-tf-state-${var.env}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  logging {
    target_bucket = aws_s3_bucket.log.id
    target_prefix = "logs/${var.prefix}-tf-state-${var.env}/"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Description = "Terraform state storage bucket"
    Environment = var.env
    Prefix      = var.prefix
  }
}

// ensures synchronous access to the
// shared state
resource "aws_dynamodb_table" "lock" {
  name           = "${var.prefix}-tf-state-lock-${var.env}"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Description = "Terraform state lock table"
    Environment = var.env
    Prefix      = var.prefix
  }
}

