output "domain" {
  value = aws_acm_certificate.cert[0].domain_name
}

output "arn" {
  value = aws_acm_certificate.cert[0].arn
}