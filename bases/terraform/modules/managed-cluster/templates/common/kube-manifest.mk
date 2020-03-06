kube_apply_opts  ?=
kube_delete_opts ?=
manifests        ?=
namespace        ?= default

ifndef manifests
$(error cannot apply unless manifests are provided, e.g., manifests := 1.yml 2.yml)
endif

# Applies the provided manifests
.PHONY: create-manifests
create-manifests:
	$(foreach manifest,$(manifests),\
		$(KUBECTL) apply --namespace $(namespace) $(kube_apply_opts) -f $(manifest) && ) true

# Deletes the provided manifests
.PHONY: delete-manifests
delete-manifests:
	$(foreach manifest,$(manifests),\
		$(KUBECTL) delete --namespace $(namespace) $(kube_delete_opts) --ignore-not-found=true -f $(manifest) &&) true
