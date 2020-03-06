variable "enabled" {
  description = "If true, the resources of this module will be created"
  type        = bool
  default     = true
}

variable "env" {
  description = "The environment the application is running in"
  type        = string
}

variable "prefix" {
  description = "A unique prefix"
  type        = string
}

variable "zone_id" {
  description = "The hosted zone where the certificate validation record will be created"
  type        = string
}

variable "domain" {
  description = "The domain that the certificate will be created for"
  type        = string
}
