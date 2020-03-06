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

variable "name" {
  description = "The name of the secret"
  type        = string
}

variable "placeholder" {
  description = "The initial value"
  type        = string
  default     = "WE_DONT_CARE"
}