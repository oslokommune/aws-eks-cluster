# eksctl https://eksctl.io/
#
# The official AWS CLI for creating EKS clusters,
# nodegroups, service accounts and more.
EKSCTL := $(shell command -v eksctl 2> /dev/null)
$(EKSCTL):
	$(error eksctl is missing, please install)

# kubectl https://kubectl.docs.kubernetes.io/
#
# The official Kubernetes CLI for interacting with
# Kubernetes clusters
KUBECTL := $(shell command -v kubectl 2> /dev/null)
$(KUBECTL):
	$(error kubectl is missing, please install)

# helm https://helm.sh/
#
# A CLI used for installing kubernetes applications
HELM := $(shell command -v helm 2> /dev/null)
$(HELM):
	$(error helm is missing, please install)

# jq https://stedolan.github.io/jq/
#
# A CLI for interracting with JSON data on
# the command line
JQ := $(shell command -v jq 2> /dev/null)
$(JQ):
	$(error jq is missing, please install)

# aws https://aws.amazon.com/cli/
#
# The AWS CLI for managing AWS resources
AWS := $(shell command -v aws 2> /dev/null)
$(AWS):
	$(error aws is missing, please install)

# sed https://www.gnu.org/software/sed/
#
# A CLI for manipulating files in-place
SED := $(shell command -v sed 2> /dev/null)
$(SED):
	$(error sed is missing, please install)

# curl https://curl.haxx.se/
#
# A CLI for transferring data with URLs
CURL := $(shell command -v curl 2> /dev/null)
$(CURL):
	$(error curl is missing, please install)

# docker-credential-ecr-login https://github.com/awslabs/amazon-ecr-credential-helper#docker
#
# A CLI for managing ECR login from docker
# easier
CRED_ECR := $(shell command -v docker-credential-ecr-login 2> /dev/null)
$(CRED_ECR):
	$(error docker-credential-ecr-login is not available, please install)

# saml2aws https://github.com/Versent/saml2aws
#
# A CLI for making logging into AWS accounts
# from SSO easier
SAML2AWS := $(shell command -v saml2aws 2> /dev/null)
$(SAML2AWS):
	$(error saml2aws is not available, please install)

# terraform https://www.terraform.io/
#
# A CLI for managing infrastructure as a code
TERRAFORM := $(shell command -v terraform 2> /dev/null)
$(TERRAFORM):
	$(error terraform is not available, please install)
