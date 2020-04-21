# Auto-generated, do not edit.
#
# Makefile for managing loki:
# 	https://github.com/grafana/loki/tree/master/production/helm
#
# This stub can be used directly, and is otherwise recursively
# applied from the root Makefile

include ../../common/cli.mk

manifests := datasource.yml
namespace := monitoring
include ../../common/kube-manifest.mk

# Uncomment the line below if namespace above is removed
#namespace       := monitoring
repository_url  := https://grafana.github.io/loki/charts
repository_name := loki
chart           := loki/loki-stack
version         := 0.36.0
release_name    := loki-stack-aws
include ../../common/kube-helm.mk

.PHONY: create delete view
create: | create-manifests create-chart
delete: | delete-chart delete-manifests
view:
	$(info not implemented yet)
