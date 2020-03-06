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

variable "availability_zones" {
  description = "The availability zones the cluster is available in"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the cluster VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "vpc_private_subnets" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "vpc_private_subnets_cidr_blocks" {
  description = "The CIDR blocks of the private subnets"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "The IDs of the public subnets"
  type        = list(string)
}

variable "vpc_public_subnets_cidr_blocks" {
  description = "The CIDR blocks of the public subnets"
  type        = list(string)
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
