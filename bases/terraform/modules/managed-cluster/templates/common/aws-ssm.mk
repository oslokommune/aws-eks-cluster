parameters ?=
region     ?=
profile    ?=

ifndef parameters
$(error parameters must be set, e.g., parameters := /some/path)
endif

ifndef region
$(error region must be set, e.g., region := eu-west-1)
endif

ifndef profile
$(error profile must be set, e.g., profile := saml2aws-terraform-profile)
endif

.PHONY: $(parameters)
$(parameters):
	$(if $(filter-out WE_DONT_CARE,$(shell $(AWS) --profile $(profile) --region $(region) ssm get-parameter \
		--name $@ --with-decryption | $(JQ) -r '.Parameter.Value')),$(info secret already set for $@),\
			@read -p "File for $@ (absolute path): " client_secret; \
				$(AWS) --profile $(profile) --region $(region) ssm put-parameter \
					--name $@ --type "SecureString" --value `cat $$client_secret` \
						--overwrite)


.PHONY: update-parameters
update-parameters: $(parameters)
