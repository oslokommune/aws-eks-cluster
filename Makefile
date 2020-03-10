SHELL   = bash
PROFILE = saml2aws-terraform-profile
REGION  = eu-west-1

ENV ?=
ifndef ENV
$(error ENV variable must be set)
endif

# This will include all CLIs that are required
# by the base makefiles.
include resources/makefile-stubs/cli.mk

ifeq ($(MAKECMDGOALS),bootstrap)
include resources/makefile-stubs/bootstrap.mk
include resources/makefile-stubs/aws.mk
include resources/makefile-stubs/terraform.mk
else
include $(ENV)/terraform/config.mk
include resources/makefile-stubs/aws.mk
include resources/makefile-stubs/terraform.mk
.PHONY: create delete login
create:
	$(MAKE) --directory=$(ENV)/cluster TARGET=create
delete:
	$(MAKE) --directory=$(ENV)/cluster TARGET=delete
login: aws-login
	@echo "! Configuring kubeconfig using eksctl"
	@$(EKSCTL) utils write-kubeconfig --cluster vv-cluster-$(ENV) --region $(REGION) --profile $(PROFILE) > /dev/null
	@echo "! Checking that kubectl is configured correctly"
	@$(KUBECTL) version > /dev/null
	@echo "! Configured successfully"
	@echo "! Run the following command now: 'source $(ENV)/terraform/local-dev'"
endif
