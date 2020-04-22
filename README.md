# AWS EKS Cluster

**THIS DOCUMENTATION IS NOT COMPLETE YET, IT IS A WIP**

This is a work in progress and should not be used unless you know what you are doing. The purpose of this repository is to provide building blocks for easily getting an EKS cluster up and running on your AWS account with a relatively sane set of defaults. 

## Getting started

### Prerequisites

1. Install [helm](https://helm.sh/)
    - MacOS: `brew install kubernetes-helm`
    - Note: This needs to be version 3.0 or newer, e.g., without Tiller
1. Install [saml2aws](https://github.com/Versent/saml2aws)
    - MacOS: `brew install saml2aws`
1. Install [terraform](https://www.terraform.io/)
    - MacOS: `brew install terraform`
1. Install [aws-cli](https://aws.amazon.com/cli/)
    - MacOS: `brew install aws-cli`
1. Install [eksctl](https://eksctl.io)
    - MacOS: `brew tap weaveworks/tap && brew install weaveworks/tap/eksctl`
1. Install [docker](https://docs.docker.com/install/)
    - MacOS: `brew install docker`
1. Install [docker-credential-ecr-login](https://github.com/awslabs/amazon-ecr-credential-helper)
    - MacOS: `brew install docker-credential-ecr-login`
1. Configure [docker-credential-ecr-login](https://github.com/awslabs/amazon-ecr-credential-helper)
1. Get access to the AWS accounts for the defined environments: `find . -name config.mk -print -exec cat {} \;`
1. Configure `saml2aws`

#### saml2aws

1. Run `saml2aws configure`
2. Your configuration should look like the one below (`cat ~/.saml2aws`), the only real difference is your `username` or `aws_profile`
3. The `Makefile` also expects that you store your password
         
```
[default]
app_id               =
url                  = https://login.oslo.kommune.no/auth/realms/AD/protocol/saml/clients/amazon-aws
username             = byrXXXXXX
provider             = KeyCloak
mfa                  = Auto
skip_verify          = false
timeout              = 0
aws_urn              = urn:amazon:webservices
aws_session_duration = 14400
aws_profile          = default
subdomain            =
role_arn             =
```

### Follow these steps

1. Copy the following files and directories:
    - `.gitignore`
    - `Makefile`
    - `resources/`
    - `bases/{applications, cluster}`
    - `bases/terraform/base`
    - `bases/terraform/global_variables.tf`
1. Update `bases/terraform/global_variables.tf` the `prefix` default to make sense for your team
1. Run `make boostrap`
    - This requires that you set `ENV=dev` and `IAM_ROLE=XXX`
    - The `ENV=dev` can be set to whatever you want the environment to be called
    - The `IAM_ROLE=XXX` needs to match the IAM_ROLE ARN of the AWS account you want the environment setup in
        - The ARN will look like: `arn:aws:iam::********:role/oslokommune/iamadmin-SAML`
1. This will setup terraform remote state, if all looks good answer `yes`
1. Now we will continue with setting up our environment
1. Copy `examples/basic-cluster.tf` into `${ENV}/terraform/main.tf`
1. Modify the `local` section to match your team specific setup
1. Add the argocd and grafana oauth apps: https://github.com/organizations/oslokommune/settings/applications
    - https://grafana.monit.veiviser-dev.oslo.systems/
    - https://grafana.monit.veiviser-dev.oslo.systems/login/github
    - https://argocd.veiviser-dev.oslo.systems/applications
    - https://argocd.veiviser-dev.oslo.systems/api/dex/callback
1. Run: `ENV=dev make tf-init`
1. Run: `cd ${ENV}/terraform && source local-dev && terraform plan -out staged.tfplan`
1. Run: `terraform apply staged.tfplan` if this looks good
1. Run: `cd ${ENV}/cluster && make create`
1. Run: `kubectl apply -f bases/applications/namespace.yml`
1. Run: `cd ${ENV}/applications/echo && make create`

```bash
export ENV=dev
make bootstrap
# Copy the content of examples/basic_cluster into ${ENV}/terraform/main.tf
# Modify ${ENV}/terraform/main.tf so it matches your requirements
make tf-init
cd ${ENV}/terraform
source local-development
terraform plan -out staged.tfplan
terraform apply staged.tfplan
docker pull hashicorp/http-echo:0.2.3
docker tag docker pull hashicorp/http-echo:0.2.3 ${ECHO_ECR_REPOSITORY_NAME}
docker push ${ECHO_ECR_REPOSITORY_NAME}
cd ..
make create
cd applications/echo
make create
```

## Deployment

We use [Argo CD](https://argoproj.github.io/argo-cd/) for deployments. This is based on a gitops pattern, e.g., the source of truth for what is deployed to your Kubernetes cluster resides in your git repository. Argo CD will watch that git repository and keep the deployed state up to date. 

## Directory layout

We use a [directory layout](https://kubectl.docs.kubernetes.io/pages/app_composition_and_deployment/structure_directories.html) that matches closely to that of [kustomize](https://kustomize.io/). The implication being that all environments are stored in the same repository. This is obviously not the only choice out there, but one that makes relative sense, and appears to be in use by many projects.

### bases

This directory contains the base structure, e.g., parallel to this directory we will find the different evironments, which override the base when required.

#### applications

Contains definitions specific to your project

#### cluster

Contains definitions for cluster functionality, this is typically integrations with AWS, e.g, EBS, ALB, Route53, Autoscaling, etc.

#### terraform

Contains reusable modules for easily setting up a VPC that is compatible with `eksctl`, etc.

## FAQ

1. Sometimes the CloudFormation stacks end up in a failure state, where they are rolled back. In these cases it may be required to delete the cloud formation stack for the failed component, fix the definition and then try to create it again.

## Worklow for modifying infrastructure or cluster

```bash
# Set the environment you want to work on
$ export ENV=dev

# Login to aws using saml2aws
$ make aws-login

# Start working with terraform
$ cd ${ENV}/terraform

# Set some environment variables for that env
$ source local-dev

# Work with terraform, this will generate all the files for creating the EKS cluster
$ terraform plan -out staged.tfplan && terraform apply staged.tfplan

# Create the EKS cluster
$ cd .. && make create
```

### Using the makefiles

There are targets within each nodegroup, extension or integration, where those targets can be run directly

## Tools

### aws-cli

### helm

### eksctl

[eksctl](https://eksctl.io/) is a CLI for managing Elastic Kubernetes Clusters (EKS) on AWS. We use this CLI to manage the lifecycle of the kubernetes control plane, node groups and IAM service accounts.

eksctl will create CloudFormation stacks in the configured AWS account and can be inspected there to better understand what resources have been created.

### kubectl

[kubectl](https://kubectl.docs.kubernetes.io/) is a CLI for interacting with a kubernetes cluster. It is used to deploy and manage applications and other resources. We use this to setup some default integrations between kubernetes and AWS, i.e., EBS, ALB, etc.

### terraform

[terraform](https://www.terraform.io/) is a CLI for writing declarative infrastructure as a code. We use this to create some initial infrastructure to deploy EKS in with eksctl. We also use it to generate a variety

## Cluster

### ecr-power-user
A service account for ECR Power User access, which will allow, e.g., a CI server to write to ECR.

### aws-ebs-csi-driver
https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/v0.4.0

### alb-ingress-controller
Sets up an AWS Application Load Balancer for the kubernetes Service via an `Ingress` definition.

### autoscaler
Uses auto-discovery via annotations set on the nodegroup to determine whether a nodegroup should be scalable or not.

### external-secrets
Provides an integration with AWS SSM so that parameters stored there are made available as a kubernetes `Secret`.

### external-dns
This will use an `Ingress` definition and the host field to create a domain.


## Observability

- https://github.com/helm/charts/tree/master/stable/prometheus-operator
- https://sysdig.com/blog/kubernetes-monitoring-prometheus-operator-part3/

`kubectl get servicemonitors --all-namespaces`

### Grafana


### Alertmanager

To take a closer look at triggered alarms:

```bash
kubectl -n monitoring port-forward service/alertmanager-operated 9093:9093
http://localhost:9093/
```

### Prometheus

```bash
kubectl -n monitoring port-forward service/prometheus-operated 9090:9090
http://localhost:9090/
```

### Loki

Logs

# Important tasks

- Need to add commands for rolling over node groups, i.e., for upgrading node groups to the latest version.
- Need to add update/upgrade functionality for all the cluster components.
- Ensure that we do not delete CRDs prematurely
    - This will delete all resources created using those CRDs
- Ensure that namespace usage for cluster resources make sense
- Verify that the account one is attempting to create EKS stuff in matches the one activated
- Improve the overall state of the documentation
- Add security group to public API endpoint to limit IPs
- Run the kube-bench security advisor
- Enable security image scanning on ECR repositories, use it as part of the CI/CD pipeline
- Add Client VPN endpoint to lock down access to the EKS API endpoint
