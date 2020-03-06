# Auto-generated, do not edit.
#
# This stub can be used directly, and is otherwise recursively
# applied from the root Makefile

cluster      := ${cluster}
nodegroups   := ${node_groups}
extensions   := ${extensions}

.PHONY: create delete $(cluster) $(nodegroups) $(extensions)

# Setup targets
create: TARGET=create
create: | $(cluster) $(nodegroups) $(extensions)
delete: TARGET=delete
delete: | $(extensions) $(nodegroups) $(cluster)

# Invoke make recursively for all provided targets
$(cluster) $(nodegroups) $(extensions):
	$(MAKE) --directory=$@ $(TARGET)
