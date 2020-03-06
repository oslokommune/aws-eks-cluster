# Auto-generated, do not edit.
#
# Makefile for managing prometheus operator:
# 	- https://github.com/helm/charts/tree/master/stable/prometheus-operator
# 	- https://sysdig.com/blog/kubernetes-monitoring-prometheus-operator-part3/
#
# This stub can be used directly, and is otherwise recursively
# applied from the root Makefile
#

include ../../common/cli.mk

parameters := ${parameters}
region     := ${region}
profile    := ${profile}
include ../../common/aws-ssm.mk

manifests := ${manifests}
include ../../common/kube-manifest.mk

namespace       := monitoring
repository_url  := https://kubernetes-charts.storage.googleapis.com
repository_name := stable
chart           := stable/prometheus-operator
version         := 8.5.0
release_name    := promtheus-operator-eks
include ../../common/kube-helm.mk

.PHONY: create delete view
create: | update-parameters create-manifests create-chart
delete: | delete-chart delete-manifests
update: | update-chart
view:
	$(info not yet implemented)
