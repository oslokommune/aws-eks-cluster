variable "env" {
  description = "The type of environment, e.g., production, staging, development"
  type        = string
}

variable "prefix" {
  description = "A unique prefix for all resources, e.g., ok-origo-veiviser"
  type        = string
}

variable "region" {
  description = "The AWS region that the resources will be created in"
  type        = string
}

variable "application" {
  description = "The name of the application associated with this database"
  type        = string
}

variable "db_name" {
  description = "The name of the data"
  type        = string
}

variable "admin_username" {
  description = "The master username for the storage"
  type        = string
}

variable "namespace" {
  description = "The namespace that shared secrets should be created in"
  type        = string
}

variable "subnets" {
  description = "The subnets that the database will be associated with"
  type        = list(string)
}

variable "subnets_cidrs" {
  description = "The CIDRs of the database subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "The id of the VPC where resources will be placed"
  type        = string
}

variable "dns_name" {
  description = "The DNS name used to create an alias to the RDS instance"
  type        = string
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone to create the alias to the db for"
  type        = string
}

variable "allocated_storage" {
  description = "The amount of allocated storage"
  type        = number
  default     = 5
}

variable "db_instance_type" {
  description = "The type of instance to be used for hosting the postgres database"
  type        = string
  default     = "db.t3.micro"
}

variable "family" {
  description = "The storage family"
  type        = string
  default     = "postgres11"
}

variable "major_engine_version" {
  description = "The major version of postgres"
  type        = string
  default     = "11"
}

variable "engine_version" {
  description = "The specific version of postgres to use"
  type        = string
  default     = "11.10"
}

variable "deletion_protection" {
  description = "Protect the resource from deletion"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "application_configuration_path" {
  description = "Location of the application folder to write the generated output files to"
  type        = string
  default     = "../applications"
}

variable "permissions_boundary_arn" {
  description = "The ARN of the permissions boundary"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to use for CI"
  type        = string
  default     = "t2.small"
}

variable "desired_capacity" {
  description = "The desired capacity of the ASG"
  type        = number
  default     = 1
}

variable "autoscaling" {
  description = "Should autoscaling be enabled for the nodegroup"
  type        = bool
  default     = true
}

variable "max_capacity" {
  description = "If autoscaling is enabled, set the maximum capacity"
  type        = number
  default     = 3
}
