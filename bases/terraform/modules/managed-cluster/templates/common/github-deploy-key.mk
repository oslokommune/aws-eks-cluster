public_key   ?=
email        ?=
repositories ?=

ifndef public_key
$(error public_key must be set)
endif

ifndef email
$(error email must be set)
endif

ifndef repositories
$(error repositories must be set)
endif

ifndef GITHUB_ACCESS_TOKEN
$(error GITHUB_ACCESS_TOKEN must be set)
endif

.PHONY: create-deploy-key
create-deploy-key:
	@$(foreach r,$(repositories),\
		$(CURL) -X POST -H"Authorization: token $(GITHUB_ACCESS_TOKEN)" \
			--data "{\"title\":\"$(email)\",\"key\":\"$(public_key)\",\"read_only\":false}" \
				https://api.github.com/repos/$(basename $(r))/$(subst .,,$(suffix $(r)))/keys &&) true
