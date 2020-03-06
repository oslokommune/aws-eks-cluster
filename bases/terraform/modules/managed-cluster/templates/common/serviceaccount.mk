# Service accounts:
# 	https://eksctl.io/usage/iamserviceaccounts/
# 	https://docs.aws.amazpath.moduleon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
.service-account := service_account.yml

$(.service-account):
	$(error cannot create or delete the service account if no configuration is provided)

# Creates a kubernetes service account and annotates this with
# an AWS IAM role. A pod associated with this service account
# can then perform the operations towards AWS API that are
# specified by its policy.
.PHONY: create-serviceaccount
create-serviceaccount: $(.service-account)
	$(EKSCTL) create iamserviceaccount \
		--config-file $(.service-account) \
		--override-existing-serviceaccounts \
		--approve

# Deletes the kubernetes service account and its IAM counterpart
.PHONY: delete-serviceaccount
delete-serviceaccount: $(.service-account)
	$(EKSCTL) delete iamserviceaccount \
		--config-file $(.service-account) \
		--approve
