.DEFAULT_GOAL := help
.PHONY: help build push start ps api-print-logs db-print-logs api-follow-logs \
		db-follow-logs api-bash db-connect ls-images rm rm-images

BRANCH      := $(shell git rev-parse --abbrev-ref HEAD)
#VERSION     := $(shell git describe --tags --abbrev=0)

include env/dev.env
#export

#ifeq ($(BRANCH),master)
#	ENV = prod
#	NAME := $(DOCKER_FOLDER_NAME)
#	IMG_TAG := $(VERSION)
#else
#	ENV = dev
#	NAME := $(DOCKER_FOLDER_NAME)-$(ENV)
#	IMG_TAG := $(VERSION)-$(ENV)
#endif

#BUILD_ARGS :=
#COMPOSE_ARGS :=

help:
	@echo "Usage: make command"
	@echo ""
	@echo "Commands:"
	@echo "  build            Build images using Dockerfile to local repository"
	@echo "  push             Push images from local to remote repository"
	@echo "  start            Start container(s) on docker compose"
	@echo "  ps               List running containers from compose"
	@echo "  api-print-logs   Show $(DOCKER_FOLDER_NAME)_$(DOCKER_API_SERVICE) print api service logs"
	@echo "  db-print-logs    Show $(DOCKER_FOLDER_NAME)_$(DOCKER_DB_SERVICE) print db service logs"
	@echo "  api-follow-logs  Show $(DOCKER_FOLDER_NAME)_$(DOCKER_API_SERVICE) follow api service logs"
	@echo "  db-follow-logs   Show $(DOCKER_FOLDER_NAME)_$(DOCKER_DB_SERVICE) follow db service logs"
	@echo "  api-bash         Open api bash for $(DOCKER_FOLDER_NAME)_$(DOCKER_API_SERVICE) service"
	@echo "  db-connect       Open db GUI for $(DOCKER_FOLDER_NAME)_$(DOCKER_DB_SERVICE) service"
	@echo "  ls-images        List images used by docke compose in the Project"
	@echo "  rm               Remove container from docker compose"
	@echo "  rm-images        Delete images from local and remote repository"
	@echo ""

build:
	@docker build -t konkah/$(DOCKER_TAG) -f containers/$(DOCKER_FILE).Dockerfile .

start:
	@docker-compose -f containers/dev.docker-compose.yml up -d

ps:
	@docker-compose -f containers/dev.docker-compose.yml ps

api-print-logs:
	@docker logs $(DOCKER_FOLDER_NAME)_$(DOCKER_API_SERVICE)_1

db-print-logs:
	@docker logs $(DOCKER_FOLDER_NAME)_$(DOCKER_DB_SERVICE)_1

api-follow-logs:
	@docker logs $(DOCKER_FOLDER_NAME)_$(DOCKER_API_SERVICE)_1 --follow

db-follow-logs:
	@docker logs $(DOCKER_FOLDER_NAME)_$(DOCKER_DB_SERVICE)_1 --follow

api-bash:
	@docker exec -it $$(docker ps --filter name=$(DOCKER_FOLDER_NAME)_$(DOCKER_API_SERVICE) -q) bash

test-api:
	@docker exec -it -w /var $$(docker ps --filter name=$(DOCKER_FOLDER_NAME)_$(DOCKER_API_SERVICE) -q) pytest

db-connect:
	@dbeaver -con "name=$(MYSQL_USER)|driver=mysql|host=$(MYSQL_HOST)|\
	database=$(MYSQL_DATABASE)|openConsole=true|port=$(MYSQL_PORT)|user=$(MYSQL_USER)|\
	password=$(MYSQL_PASSWORD)|allowPublicKeyRetrieval=true"

ls-images:
	@docker-compose -f containers/dev.docker-compose.yml images

finish:
	@echo ">>>>> Remove containers $(DOCKER_FOLDER_NAME)"
	@docker-compose -f containers/dev.docker-compose.yml down --rmi local --remove-orphans

rm-images:
	@echo ">>>>> Remove images $(DOCKER_FOLDER_NAME)"
	docker rmi -f $(docker-compose images -q)
