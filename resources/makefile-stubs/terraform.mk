.BACKEND_HCL := backend.hcl
.PROFILE 	 := saml2aws-terraform-profile

.TF_INIT_OPTIONS    ?= -var 'env=$(ENV)' -backend-config=$(.BACKEND_HCL) -reconfigure

mkfile_path := $(shell pwd)
env_dir     := $(mkfile_path)/$(ENV)/terraform

# Initialise the terraform repository
tf-init:
	cd $(env_dir) && AWS_PROFILE=$(.PROFILE) $(TERRAFORM) init $(.TF_INIT_OPTIONS)
	@echo "To start working with terraform, source the 'local-dev' file in: $(env_dir)/local-dev"
.PHONY: tf-init

