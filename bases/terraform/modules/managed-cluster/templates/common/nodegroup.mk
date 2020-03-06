# Node group:
# 	https://eksctl.io/usage/managing-nodegroups/
# 	https://docs.aws.amazon.com/eks/latest/userguide/worker.html
.nodegroup := node_group.yml

$(.nodegroup):
	$(error cannot create or delete the node group if no configuration is provided)

# Creates a node group using eksctl and adds it to the EKS cluster
.PHONY: create-nodegroup
create-nodegroup: $(.nodegroup)
	$(EKSCTL) create nodegroup \
		--config-file $(.nodegroup)

# Drains and deletes the nodegroup using eksctl
.PHONY: delete-nodegroup
delete-nodegroup: $(.nodegroup)
	$(EKSCTL) delete nodegroup \
		--config-file $(.nodegroup) \
		--drain \
		--approve
