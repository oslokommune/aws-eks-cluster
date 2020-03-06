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

variable "region" {
  description = "The AWS region of the EKS cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "permissions_boundary_arn" {
  description = "The ARN of the permissions boundary that the role must be created in"
  type        = string
}

variable "cluster_configuration_path" {
  description = "Location of the cluster folder to write the generated output files to"
  type        = string
}

variable "bases_configuration_path" {
  description = "Location of the bases folder, relative to this directory"
  type        = string
}
