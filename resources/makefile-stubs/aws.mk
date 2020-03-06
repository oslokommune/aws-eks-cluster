.REGION := eu-west-1
.PROFILE := saml2aws-terraform-profile

IAM_ROLE ?=
ifndef IAM_ROLE
$(error IAM_ROLE variable must be set)
endif

os := $(shell uname)
SKIP_PROMPT ?=
ifeq ($(os),Darwin)
SKIP_PROMPT := --skip-prompt
endif

aws-login:
ifeq ($(SKIP_LOGIN),true)
	$(info Skipping AWS login)
else
	$(SAML2AWS) login --force --role=$(IAM_ROLE) --profile $(.PROFILE) $(SKIP_PROMPT)
endif
.PHONY: aws-login

ifndef AWS_PROFILE_CONTENT
define AWS_PROFILE_CONTENT
[$(.PROFILE)]
aws_access_key_id=$(AWS_ACCESS_KEY_ID)
aws_secret_access_key=$(AWS_SECRET_ACCESS_KEY)
endef
export AWS_PROFILE_CONTENT
endif

ifndef AWS_CONFIG_CONTENT
define AWS_CONFIG_CONTENT
[$(.PROFILE)]
region=$(.REGION)
output=json
endef
export AWS_CONFIG_CONTENT
endif

.AWS_DIR := $(HOME)/.aws
$(.AWS_DIR):
	mkdir -p $(.AWS_DIR)

aws-add-creds: $(.AWS_DIR)
	@echo "$$AWS_PROFILE_CONTENT" >> $(.AWS_DIR)/credentials
	@echo "$$AWS_CONFIG_CONTENT" >> $(.AWS_DIR)/config
.PHONY: aws-add-creds
