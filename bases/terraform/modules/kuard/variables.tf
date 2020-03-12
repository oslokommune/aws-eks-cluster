variable "env" {
  description = "The environment the application is running in"
  type        = string
}

variable "prefix" {
  description = "A unique prefix"
  type        = string
}

variable "namespace" {
  description = "The namespace the resources should be created in"
  type        = string
}

variable "git_path" {
  description = "The path where the echo application will be installed"
  type = string
}

variable "git_url" {
  description = "The git url to the repository where the code is located"
  type = string
}

variable "application_configuration_path" {
  description = "Location of the application folder to write the generated output files to"
  type        = string
  default     = "../applications"
}

variable "bases_configuration_path" {
  description = "Location of the bases folder, relative to this directory"
  type        = string
  default     = "../../../bases/applications"
}
