kube_apply_opts  ?=
kube_delete_opts ?=
secret_file      ?=
remote_file      ?= $(secret_file)
user_input       ?=
name             ?=
namespace        ?= default

ifndef secret_file
$(error cannot apply unless secret_file is provided, e.g., secret_file := secret.yml)
endif

ifndef user_input
$(error cannot apply unless user_input is provided, e.g., user_input := SLACK_WEBHOOK)
endif

ifndef name
$(error cannot apply unless name is provided, e.g., name := secret_namee)
endif

$(secret_file).orig:
	@read -p "Value for $(user_input): " value; \
		$(SED) -i.orig "s@$(user_input)@$$value@" $(secret_file)

# Creates a kubernetes secret using input from user
.PHONY: create-secret
create-secret: $(secret_file).orig
	$(if $(KUBECTL) get secret $(name) --namespace $(namespace) --no-headers --ignore-not-found,,\
		$(KUBECTL) create secret generic $(name) --namespace $(namespace) $(kube_apply_opts) --from-file=$(remote_file)=$(secret_file) && \
			mv $(secret_file).orig $(secret_file))

# Deletes a kubernetes secret
.PHONY: delete-secret
delete-secret:
	$(KUBECTL) delete secret $(name) --namespace $(namespace) $(kube_delete_opts) --ignore-not-found=true
