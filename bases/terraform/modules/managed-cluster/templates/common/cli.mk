# eksctl https://eksctl.io/
#
# The official AWS CLI for creating EKS clusters,
# nodegroups, service accounts and more.
#
# For eksctl to work with our AWS accounts, we need
# to be able to provide permissions boundaries to the
# IAM identities that are created. Currently this isn't
# supported by eksctl, but we have a PR in progress,
# once this has been merged, we can remove the local
# dependency.
#
# Github issue:
#	https://github.com/weaveworks/eksctl/pull/1638
#
# Once PR is merged uncomment this lint:
# 	EKSCTL  := $(shell command -v eksctl 2> /dev/null)
EKSCTL  := $(HOME)/src/eksctl/eksctl
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