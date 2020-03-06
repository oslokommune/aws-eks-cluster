# Auto-generated, do not edit.
#
# Makefile for managing backend
#
# This stub can be used directly, and is otherwise recursively
# applied from the root Makefile

include ../../common/cli.mk

namespace := argocd
manifests := application.yml
include ../../common/kube-manifest.mk

include ../../common/kube-kustomize.mk

.PHONY: create delete view
create: | create-kustomization create-manifests
delete: | delete-manifests delete-kustomization
view:
	$(info does not apply)
