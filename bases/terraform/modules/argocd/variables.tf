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

variable "domain" {
  description = "The domain name that argocd should be associated with"
  type        = string
}

variable "zone_id" {
  description = "The route53 hosted zone id"
  type        = string
}

variable "email" {
  description = "The email to be associated with the deploy keys"
  type        = string
}

variable "repositories" {
  description = "Github repositories"
  type = list(object({
    url          = string,
    name         = string
    repository   = string,
    organisation = string,
  }))
}

variable "github_authentication" {
  description = "Configuration details for setting up github authentication"
  type = object({
    organisation     = string
    team             = string
    argocd_client_id = string
  })
}

variable "cluster_configuration_path" {
  description = "Location of the cluster folder to write the generated output files to"
  type        = string
}
