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

variable "domain" {
  description = "The base domain for the EKS cluster, from which to create ingresses, etc."
  type        = string
}

variable "email" {
  description = "An email for contacting the team / group / entity that manages the cluster"
  type        = string
}

variable "permissions_boundary_arn" {
  description = "The ARN of the permissions boundary that makes creating IAM entities possible"
  type        = string
}

variable "enable_alb_ingress_controller" {
  description = "By setting this to true, you can use annotations to create ALBs for ingress traffic"
  type        = bool
  default     = true
}

variable "enable_autoscaler" {
  description = "By setting this to true, you get nodegroups that are autoscaled based resource consumption"
  type        = bool
  default     = true
}

variable "enable_ebs_csi_driver" {
  description = "By setting this to true, you can create block storage on AWS EBS"
  type        = bool
  default     = true
}

variable "enable_external_dns" {
  description = "By setting this to true, you can create CNAMEs in route53 to your instances"
  type        = bool
  default     = true
}

variable "enable_external_secrets" {
  description = "By setting this to true, you can reference secrets created in AWS SSM"
  type        = bool
  default     = true
}

variable "enable_ecr_power_user" {
  description = "By setting this to true, you can use a service account to push images to ECR repos"
  type        = bool
  default     = true
}

variable "enable_nodegroup_generic" {
  description = "By setting this to true, you get a nodegroup for use with all types of applications"
  type        = bool
  default     = true
}

variable "deployment" {
  description = "Setup deployment of applications to the cluster with authenticated access"
  type = object({
    enabled = bool
    email = string

    repositories = list(object({
      url          = string,
      name         = string,
      repository   = string,
      organisation = string,
    }))

    github_authentication = object({
      organisation     = string
      team             = string
      argocd_client_id = string
    })
  })
}

variable "monitoring" {
  description = "Setup monitoring of the cluster with authenticated access"
  type = object({
    enabled = bool

    github_authentication = object({
      organisation      = string
      team_id           = string
      grafana_client_id = string
    })
  })
}

variable "vpc_cidr" {
  description = "The CIDR used when creating the VPC"
  type        = string
  default     = "10.50.0.0/16"
}

variable "private_subnets_cidrs" {
  description = "The CIDRs used for creating the private subnets"
  type        = list(string)
  default     = ["10.50.1.0/24", "10.50.2.0/24", "10.50.3.0/24"]
}

variable "public_subnets_cidrs" {
  description = "The CIDRs used for creating the public subnets"
  type        = list(string)
  default     = ["10.50.11.0/24", "10.50.12.0/24", "10.50.13.0/24"]
}

variable "database_subnets_cidrs" {
  description = "The CIDRs used for creating the database subnets"
  type        = list(string)
  default     = ["10.50.21.0/24", "10.50.22.0/24", "10.50.23.0/24"]
}

variable "cluster_configuration_path" {
  description = "Location of the cluster folder to write the generated output files to"
  type        = string
  default     = "../cluster"
}

variable "common_configuration_path" {
  description = "Location of the common makefiles"
  type        = string
  default     = ".."
}

variable "bases_configuration_path" {
  description = "Location of the bases folder, relative to this directory"
  type        = string
  default     = "../../../bases/cluster"
}
