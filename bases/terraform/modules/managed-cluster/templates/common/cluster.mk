# Cluster:
# 	https://eksctl.io/usage/creating-and-managing-clusters/
#
cluster_name ?=
region       ?=

ifndef cluster_name
$(error cluster_name must be set, so we can fetch the cluster)
endif

ifndef region
$(error region must be set, so we can fetch the cluster)
endif

.cluster := cluster.yml

$(.cluster):
	$(error cannot create or delete the cluster if no configuration is provided)

# Creates a cluster using eksctl
.PHONY: create-cluster
create-cluster: $(.cluster)
	$(EKSCTL) create cluster \
		--config-file $(.cluster)

# Deletes the cluster using eksctl
.PHONY: delete-cluster
delete-cluster: $(.cluster)
	$(EKSCTL) delete cluster \
		--config-file $(.cluster)
