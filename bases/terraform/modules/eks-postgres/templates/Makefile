# Auto-generated, do not edit.
#
# Makefile for managing the postgres external secrets:
# 	https://github.com/godaddy/kubernetes-external-secrets#add-a-secret
#
# This stub can be used directly, and is otherwise recursively
# applied from the root Makefile
#
# NB: This doesn't currently work as well as one would wish.
# For the time being it is better to add certificates to terraform
# and reuse the arn where applicable.

include ../../common/cli.mk
include ../../common/nodegroup.mk

manifests := ${manifests}
namespace := ${namespace}
include ../../common/kube-manifest.mk

.PHONY: create delete view
create: | create-nodegroup create-manifests
delete: | delete-manifests delete-nodegroup
view:
	$(info does not apply yet, FIXME)
