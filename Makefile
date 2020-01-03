.DEFAULT_GOAL:=help

DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
DIR_TF_REPO := "$(DIR)/aws/repo"
DIR_TF_APP := "$(DIR)/aws/app"
DIR_OUTPUTS := "$(DIR)/.outputs"
DIR_SRC := "$(DIR)/src"

.PHONY: help
help: ## This help text.
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Terraform

.PHONY: ecr
ecr: ## Deploy the ECR for the Hubot image
	@cd "$(DIR_TF_REPO)" ; terraform init ;
	@cd "$(DIR_TF_REPO)" ; terraform apply -auto-approve ;
	@mkdir -p $(DIR_OUTPUTS)
	@cd "$(DIR_TF_REPO)" ; terraform output repository_url > $(DIR_OUTPUTS)/ecr_url ;

.PHONY: ecs
ecs: ## Deploy the Hubot ECS service
	@cd "$(DIR_TF_APP)" ; terraform init ;
	@cd "$(DIR_TF_APP)" ; terraform apply -auto-approve ;
	@mkdir -p $(DIR_OUTPUTS)
	@cd "$(DIR_TF_APP)" ; terraform output secret_id > $(DIR_OUTPUTS)/secret_id ;

destroy: ## Destroys the terraform instructure
	@cd "$(DIR_TF_APP)" ; terraform init ;
	@cd "$(DIR_TF_APP)" ; terraform destroy -auto-approve ;
	@cd "$(DIR_TF_REPO)" ; terraform init ;
	@cd "$(DIR_TF_REPO)" ; terraform destroy -auto-approve ;

##@ Hubot
.PHONY: build
launch: ## Launches the hubot application in docker
	docker run -it \
		--rm \
		-e HUBOT_LOG_LEVEL="debug" \
		-e HUBOT_SECRET="$(shell cat "$(DIR_OUTPUTS)/secret_id")" \
		$(addprefix -e ,$(shell printenv | grep ^AWS_ )) \
		$(shell cat "$(DIR_OUTPUTS)/ecr_url"):latest

##@ Docker

.PHONY: docker
docker: ## Build the hubot image for deployment
	@docker build -t aws-hubot -f docker/Dockerfile .
	docker tag aws-hubot $(shell cat "$(DIR_OUTPUTS)/ecr_url"):latest

deploy: ## Deploys the hubot image to ECR
	@$(shell aws ecr get-login --no-include-email --region $(AWS_DEFAULT_REGION)) 
	@docker push $(shell cat "$(DIR_OUTPUTS)/ecr_url"):latest