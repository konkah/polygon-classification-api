.PHONY: cloud-start cloud-finish start finish api-print-logs api-bash test-api \
		db-connect kill-project

include env/dev.env

cloud-start:
	@cd terraform && terraform apply -var-file="../env/dev.tfvars" -auto-approve

cloud-finish:
	@cd terraform && terraform destroy -var-file="../env/dev.tfvars" -auto-approve

start:
	@docker compose -p $(DOCKER_PROJECT_NAME) -f containers/dev.docker-compose.yml up -d

api-print-logs:
	@docker logs $(DOCKER_PROJECT_NAME)-$(DOCKER_API_SERVICE)-1

api-bash:
	@docker exec -it $(DOCKER_PROJECT_NAME)-$(DOCKER_API_SERVICE)-1 bash
# 	@docker exec -it $$(docker ps --filter name=$(DOCKER_PROJECT_NAME)_$(DOCKER_API_SERVICE) -q) bash

db-connect:
	@dbeaver -con "name=$(MYSQL_DATABASE)|driver=mysql|host=127.0.0.1|\
	database=$(MYSQL_DATABASE)|openConsole=true|port=$(MYSQL_PORT)|user=$(MYSQL_USER)|\
	password=$(MYSQL_PASSWORD)|allowPublicKeyRetrieval=true"

test-api:
	@docker exec -it -w /var $(DOCKER_PROJECT_NAME)-$(DOCKER_API_SERVICE)-1 pytest
#	@docker exec -it -w /var $$(docker ps --filter name=$(DOCKER_PROJECT_NAME)_$(DOCKER_API_SERVICE) -q) pytest

finish:
	@echo ">>>>> Remove containers $(DOCKER_PROJECT_NAME)"
	@docker compose -p $(DOCKER_PROJECT_NAME) -f containers/dev.docker-compose.yml down --remove-orphans

kill-project:
	@echo ">>>>> Remove containers and images"
	@docker compose -p $(DOCKER_PROJECT_NAME) -f containers/dev.docker-compose.yml down --rmi local --remove-orphans
	@docker system prune -f --volumes
