IAM_ROLE ?=
ifndef IAM_ROLE
$(error IAM_ROLE is required for bootstrapping, e.g., 'ENV=dev IAM_ROLE=arn:aws:iam::... make boostrap')
endif

include aws.mk
include terraform.mk

.base         = bases/terraform
.target       = $(ENV)/terraform
.remote_state = $(.target)/remote-state
.config       = $(.target)/config.mk
.local        = $(.target)/local-dev
.plan_file    = staged.tfplan
.plan         = $(.remote_state)/$(.plan_file)

bootstrap: | aws-login $(.target) $(.remote_state) $(.config) $(.local) $(.plan)
	$(info We will now deploy the remote-state management for your new environment: $(ENV))
	@printf "Do you want to continue? [y/N] " && read ans && [ $${ans:-N} = y ]
	@cd $(.remote_state) && $(TERRAFORM) apply $(.plan_file)
	$(info Linking in configuration options of s3 backend for remote state management)
	ln -s remote-state/`$(TERRAFORM) output -state=$(.remote_state)/terraform.tfstate -json | jq -r '."shared-backend".value'` $(.target)/backend.hcl
.PHONY: bootstrap

$(.target):
	@mkdir -p $(.target)
	$(info Linking global terraform variables into main)
	@ln -s ../../$(.base)/global_variables.tf $(.target)/global_variables.tf
	$(info Staging backend and provider configuration)
	@cp $(.base)/base/versions.tf $(.base)/base/backend.tf $(.base)/base/provider.tf $(.target)/.

$(.remote_state):
	@mkdir -p $(.remote_state)
	$(info Linking global terraform variabls into remote state)
	@ln -s ../../../$(.base)/global_variables.tf $(.remote_state)/global_variables.tf
	$(info Staging terraform remote state management)
	@cp -R $(.base)/base/remote-state/. $(.remote_state)

$(.config):
	$(info Populating: $(.config) with IAM role: $(IAM_ROLE))
	@echo "IAM_ROLE = $(IAM_ROLE)" > $(.config)

$(.local):
	$(info Populating: $(.local) with local development properties)
	@echo "export AWS_REGION=eu-west-1\nexport AWS_PROFILE=saml2aws-terraform-profile\nexport TF_VAR_env=$(ENV)" > $(.local)

$(.plan):
	$(info Initialising and planning terraform remote state management)
	cd $(.remote_state) && \
		$(TERRAFORM) init -var 'env=$(ENV)' && \
		$(TERRAFORM) plan -var 'env=$(ENV)' -out $(.plan_file)

