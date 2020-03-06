# NOTE: Only edit this file from the root of the infrastructure
# directory
#
# global_variables.tf provides a set of common definitions
# that are used by the different environments. Its intention
# is to reduce duplication of variable definitions that are
# commonly reused
#
# You can use the following command to find all places this
# file is referenced:
#
#     find -L . -samefile global_variables.tf

variable "region" {
  description = "The AWS region that the resources will be created in"
  type        = string
  default     = "eu-west-1"
}

variable "profile" {
  description = "The saml2aws profile name that will be used by the providers"
  type        = string
  default     = "saml2aws-terraform-profile"
}

variable "prefix" {
  description = "A unique prefix for all resources, e.g., company-team"
  type        = string
  default     = "origo"
}

variable "env" {
  description = "The environment that these resources are being defined in, e.g., dev, pro, stage"
  type        = string
}

