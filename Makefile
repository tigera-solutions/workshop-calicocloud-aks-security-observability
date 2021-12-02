include config.mk

.DEFAULT_GOAL:=help

##@ Manage Azure Resource Manager deployments.
.PHONY: test
test: ## Validate the template.
	az deployment group validate --resource-group $(RESOURCE_GROUP_NAME) --template-file aks.json --mode Complete --parameters @aks.parameters.json --parameters \
		sshRSAPublicKey=$(SSH_PUBKEY) \
		clusterName=$(NAME)

.PHONY: deploy
deploy: ## Deploy the template.
	az deployment group create --resource-group $(RESOURCE_GROUP_NAME) --template-file aks.json --mode Complete --parameters @aks.parameters.json --parameters \
		sshRSAPublicKey=$(SSH_PUBKEY) \
		clusterName=$(NAME)

.PHONY: cleanup
cleanup: ## Cleanup the deployment leaving resource group intact.
	kubectl config delete-cluster $(NAME)
	kubectl config delete-context $(NAME)
	kubectl config unset users.clusterUser_$(RESOURCE_GROUP_NAME)_$(NAME)
	kubectl config unset current-context
	az deployment group create --resource-group $(RESOURCE_GROUP_NAME) --template-file aks.cleanup.json --mode Complete

.PHONY: teardown
teardown: ## Teardown the deployment by removing the resource group.
	az group delete --name $(RESOURCE_GROUP_NAME) 

.PHONY: list
list: ## List the deployments.
	az deployment group list --resource-group $(RESOURCE_GROUP_NAME) --output table

.PHONY: login
login: ## Login to Azure
	az login
	az account set --subscription $(SUBSCRIPTION)

.PHONY: setup
setup: ## Create the resource group and setup rbac.
	az group create --name $(RESOURCE_GROUP_NAME) --location $(LOCATION)

.PHONY: kubeconfig
kubeconfig: ## Configure kubeconfig for AKS
	az aks get-credentials --resource-group $(RESOURCE_GROUP_NAME) --name $(NAME)

##@ Help
.PHONY: help
help:  ## Type make followed by target you wish to run.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-z0-9A-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
