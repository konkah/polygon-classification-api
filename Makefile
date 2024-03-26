.PHONY: cloud-init-aws cloud-upgrade-aws cloud-plan-aws cloud-start-aws cloud-finish-aws \
		start finish api-print-logs api-bash test-api db-connect kill-project

include env/dev.env

cloud-init-aws:
	@cd architecture/cloud/terraform/aws && terraform init -reconfigure -lock=false

cloud-upgrade-aws:
	@cd architecture/cloud/terraform/aws && terraform init -upgrade

cloud-plan-aws:
	@cd architecture/cloud/terraform/aws && terraform validate -var-file="../../../../env/dev.tfvars"

cloud-plan-aws:
	@cd architecture/cloud/terraform/aws && terraform plan -var-file="../../../../env/dev.tfvars"

cloud-start-aws:
	@cd architecture/cloud/terraform/aws && terraform apply -var-file="../../../../env/dev.tfvars" -auto-approve

cloud-finish-aws:
	@cd architecture/cloud/terraform/aws && terraform destroy -var-file="../../../../env/dev.tfvars" -auto-approve

start:
	@docker compose -p $(DOCKER_PROJECT_NAME) -f architecture/local/containers/dev.docker-compose.yml up -d

api-print-logs:
	@docker logs $(DOCKER_PROJECT_NAME)-$(DOCKER_API_SERVICE)-1

api-bash:
	@docker exec -it $(DOCKER_PROJECT_NAME)-$(DOCKER_API_SERVICE)-1 bash
# 	@docker exec -it $$(docker ps --filter name=$(DOCKER_PROJECT_NAME)_$(DOCKER_API_SERVICE) -q) bash

db-connect:
	@dbeaver -con "name=$(MYSQL_DATABASE)|driver=postgres|host=127.0.0.1|\
	database=$(MYSQL_DATABASE)|openConsole=true|port=$(MYSQL_PORT_DBEAVER)|user=$(MYSQL_USER)|\
	password=$(MYSQL_PASSWORD)|allowPublicKeyRetrieval=true"

test-api:
	@docker exec -it -w /var $(DOCKER_PROJECT_NAME)-$(DOCKER_API_SERVICE)-1 pytest
#	@docker exec -it -w /var $$(docker ps --filter name=$(DOCKER_PROJECT_NAME)_$(DOCKER_API_SERVICE) -q) pytest

finish:
	@echo ">>>>> Remove containers $(DOCKER_PROJECT_NAME)"
	@docker compose -p $(DOCKER_PROJECT_NAME) -f architecture/local/containers/dev.docker-compose.yml down --remove-orphans

kill-project:
	@echo ">>>>> Remove containers and images"
	@docker compose -p $(DOCKER_PROJECT_NAME) -f architecture/local/containers/dev.docker-compose.yml down --rmi local --remove-orphans
	@docker system prune -f --volumes
