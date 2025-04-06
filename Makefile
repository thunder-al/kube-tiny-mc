DOCKER = docker
HELM = helm

CONTAINER_TEMP_NAME = kube-tiny-mc
CONTAINER_RAND_NAME := $(shell openssl rand -hex 16)

container-build:
	$(DOCKER) build -t "$(CONTAINER_TEMP_NAME)" .

# pushes container to https://ttl.sh/ for one hour with a random name
container-push-ttl-sh:
	$(DOCKER) tag "$(CONTAINER_TEMP_NAME)" "ttl.sh/$(CONTAINER_RAND_NAME):1h"
	$(DOCKER) push "ttl.sh/$(CONTAINER_RAND_NAME):1h"

helm-install:
	@if [ -z "$(NAME)" ] || [ -z "$(NAMESPACE)" ] || [ -z "$(IMAGE)" ]; then \
		echo "Please set NAME, NAMESPACE and IMAGE variables"; \
		exit 1; \
	fi

	$(HELM) upgrade --install \
		"$(NAME)" "./helm" \
		--namespace "$(NAMESPACE)" \
		--set server.image="$(IMAGE)"

deploy:
	@if [ -z "$(NAME)" ] || [ -z "$(NAMESPACE)" ]; then \
		echo "Please set NAME and NAMESPACE variables"; \
		exit 1; \
	fi

	$(MAKE) container-build
	$(MAKE) container-push-ttl-sh CONTAINER_RAND_NAME="$(CONTAINER_RAND_NAME)"
	$(MAKE) helm-install IMAGE="ttl.sh/$(CONTAINER_RAND_NAME):1h"
	@echo "Deployed $(NAME) to $(NAMESPACE) with image ttl.sh/$(CONTAINER_RAND_NAME):1h"