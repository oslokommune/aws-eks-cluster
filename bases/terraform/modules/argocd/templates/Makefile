# Auto-generated, do not edit.
#
# Makefile for managing the cluster autoscaler:
#   https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md
#	https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html
#
# This stub can be used directly, and is otherwise recursively
# applied from the root Makefile

include ../../common/cli.mk

namespace := argocd
manifests := namespace.yml argo-cd-privatekey-external.yml argo-cd-secret-external.yml
include ../../common/kube-manifest.mk

include ../../common/kube-kustomize.mk

parameters := ${parameters}
region      := eu-west-1
profile     := saml2aws-terraform-profile
include ../../common/aws-ssm.mk

public_key   := ${public_key}
email        := ${email}
repositories := %{ for r in repos }${r.organisation}.${r.repository} %{ endfor }
include ../../common/github-deploy-key.mk

.PHONY: create delete view
create: | update-parameters create-manifests create-kustomization create-deploy-key
delete: | delete-kustomization delete-manifests
view:
	$(info nope)
