# Auto-generated, do not edit.
#
# Makefile for managing ebs csi driver:
# 	https://github.com/kubernetes-sigs/aws-ebs-csi-driver
#
# This stub can be used directly, and is otherwise recursively
# applied from the root Makefile

include ../../common/cli.mk
include ../../common/serviceaccount.mk

manifests := storageclass.yml
namespace := kube-system
include ../../common/kube-manifest.mk

kustomize_apply_opts := --validate=false
include ../../common/kube-kustomize.mk

.PHONY: create delete view
create: | create-serviceaccount	create-kustomization create-manifests
delete: | delete-manifests delete-kustomization delete-serviceaccount
view:
	$(KUBECTL) logs -n $(namespace) \
		$(shell $(KUBECTL) get po -n kube-system | egrep -o "ebs[a-zA-Z0-9-]+")
