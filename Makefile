.PHONY: cloud-start cloud-finish build start finish api-print-logs api-bash test-api

include env/dev.env

cloud-start:
	@cd terraform && terraform apply -var-file="../env/dev.tfvars" -auto-approve

cloud-finish:
	@cd terraform && terraform destroy -var-file="../env/dev.tfvars" -auto-approve

build:
	@docker build -t konkah/$(DOCKER_TAG) -f containers/$(DOCKER_FILE).Dockerfile .

start:
	@docker-compose -f containers/dev.docker-compose.yml up -d

api-print-logs:
	@docker logs $(DOCKER_FOLDER_NAME)_$(DOCKER_API_SERVICE)_1

api-bash:
	@docker exec -it $$(docker ps --filter name=$(DOCKER_FOLDER_NAME)_$(DOCKER_API_SERVICE) -q) bash

test-api:
	@docker exec -it -w /var $$(docker ps --filter name=$(DOCKER_FOLDER_NAME)_$(DOCKER_API_SERVICE) -q) pytest

finish:
	@echo ">>>>> Remove containers $(DOCKER_FOLDER_NAME)"
	@docker-compose -f containers/dev.docker-compose.yml down --rmi local --remove-orphans
