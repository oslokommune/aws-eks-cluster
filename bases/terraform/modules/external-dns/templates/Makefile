# Auto-generated, do not edit.
#
# Makefile for managing the cluster autoscaler:
# 	https://github.com/kubernetes-sigs/external-dns
# 	https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md
#
# This stub can be used directly, and is otherwise recursively
# applied from the root Makefile

include ../../common/cli.mk
include ../../common/serviceaccount.mk
include ../../common/kube-kustomize.mk

.PHONY: create delete view
create: | create-serviceaccount create-kustomization
delete: | delete-kustomization delete-serviceaccount
view:
	$(KUBECTL) logs -n kube-system \
		$(shell $(KUBECTL) get po -n kube-system | egrep -o "external-dns[a-zA-Z0-9-]+")
