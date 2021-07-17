SHELL=/bin/bash
VERSION := latest

all: help ## show this help

.PHONY: build
build: ## build docker image
	docker build --no-cache -t oppara/centos6-apache-php:$(VERSION) .

.PHONY: push
push: ## push docker image
	docker push oppara/centos6-apache-php:$(VERSION)

.PHONY: bash
bash: ## bash
	docker run --rm -it oppara/centos6-apache-php bash

.PHONY: login
login: ## login container
	docker exec -it centos6-apache-php bash

.PHONY: up
up: ## docker-compose up
	docker-compose up -d

.PHONY: down
down: ## docker-compose down
	docker-compose down

.PHONY: open
open: ## open browser
	open http://127.0.0.1:8000

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
