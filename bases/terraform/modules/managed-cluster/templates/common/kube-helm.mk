namespace       ?=
repository_url  ?=
repository_name ?=
chart           ?=
release_name    ?=
version         ?= latest
atomic          ?= --atomic
.values 	    := values.yml

ifndef namespace
$(error namespace must be set, e.g., namespace := default)
endif

ifndef repository_url
$(error repository_url must be set, e.g., repository_url := https://...)
endif

ifndef repository_name
$(error repository_name  must be set, e.g., repository_name := name)
endif

ifndef chart
$(error chart must be set, e.g., chart := repo/name)
endif

ifndef release_name
$(error release_name must be set, e.g., release_name := release)
endif

$(.values):
	$(error cannot create or delete the helm chart if no values are provided)

.has_release := $(shell $(HELM) list --all-namespaces --output json | $(JQ) '.[] | select(.name=="$(release_name)")')

.PHONY: add-repository
add-repository:
	$(HELM) repo add $(repository_name) $(repository_url)
	$(HELM) repo update

# Creates a kubernetes application using the provided
# chart and the values that define the behavior.
.PHONY: create-chart
create-chart: $(.values) add-repository
	$(if $(.has_release),\
		$(info release already exists, skipping),\
		$(HELM) install $(release_name) $(chart) \
			--namespace $(namespace) --values $(.values) \
			--version $(version) $(atomic)\
	)

# Updates a kubernetes application using the provided chart
# and the values that define the behavior.
.PHONY: update-chart
update-chart: $(.values)
	$(if $(.has_release),\
		$(HELM) upgrade $(release_name) $(chart) \
			--namespace $(namespace) --values $(.values) \
			--force --version $(version) $(atomic)\
	)

# Deletes the chart and all its resources from
# kubernetes
delete-chart: $(.values)
	$(HELM) uninstall $(release_name) \
		--namespace $(namespace)
