# Auto-generated, do not edit.
#
# Makefile for managing the cluster autoscaler:
#   https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md
#	https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html
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
		$(shell $(KUBECTL) get po -n kube-system | egrep -o "autoscaler[a-zA-Z0-9-]+")
