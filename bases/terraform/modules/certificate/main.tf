locals {
  count = var.enabled ? 1 : 0
}

resource "aws_acm_certificate" "cert" {
  count             = local.count
  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = var.env
    Prefix      = var.prefix
  }
}

resource "aws_route53_record" "validation" {
  count   = local.count
  name    = aws_acm_certificate.cert[count.index].domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert[count.index].domain_validation_options[0].resource_record_type
  zone_id = var.zone_id
  records = [
    aws_acm_certificate.cert[count.index].domain_validation_options[0].resource_record_value
  ]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
  count           = local.count
  certificate_arn = aws_acm_certificate.cert[count.index].arn
  validation_record_fqdns = [
    aws_route53_record.validation[count.index].fqdn
  ]
}
