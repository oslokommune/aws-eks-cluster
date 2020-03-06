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

variable "instance_type" {
  description = "The type of instance to use for CI"
  type        = string
  default     = "m5.large"
}

variable "desired_capacity" {
  description = "The desired capacity of the ASG"
  type        = number
  default     = 3
}

variable "autoscaling" {
  description = "Should autoscaling be enabled for the nodegroup"
  type        = bool
  default     = true
}

variable "max_capacity" {
  description = "If autoscaling is enabled, set the maximum capacity"
  type        = number
  default     = 10
}
