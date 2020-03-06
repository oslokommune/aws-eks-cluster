output "arn" {
  value = aws_ssm_parameter.secret[0].arn
}

output "name" {
  value = aws_ssm_parameter.secret[0].name
}
