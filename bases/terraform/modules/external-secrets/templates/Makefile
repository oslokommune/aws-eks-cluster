# Auto-generated, do not edit.
#
# Makefile for managing cert manager:
# 	https://github.com/godaddy/kubernetes-external-secrets
#
# This stub can be used directly, and is otherwise recursively
# applied from the root Makefile

include ../../common/cli.mk
include ../../common/serviceaccount.mk

namespace       := kube-system
repository_url  := https://godaddy.github.io/kubernetes-external-secrets/
repository_name := external-secrets
chart           := external-secrets/kubernetes-external-secrets
version         := 2.2.0
release_name    := external-secrets-aws
include ../../common/kube-helm.mk

.PHONY: create delete view
create: | create-serviceaccount create-chart
delete: | delete-chart delete-serviceaccount
view:
	$(KUBECTL) logs -n $(namespace) \
		$(shell $(KUBECTL) get po -n kube-system | egrep -o "external-secrets[a-zA-Z0-9-]+")
