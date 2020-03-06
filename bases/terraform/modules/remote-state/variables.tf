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

