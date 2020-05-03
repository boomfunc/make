# This Makefile describes the behavior of a node that was handling in docker context.
include common.mk
include git.mk

# Get the docker bin path.
DOCKER := $(or $(shell which docker),/usr/local/bin/docker)

# Define docker environment. Override defaults in node's Makefile.
DOCKERFILE?=Dockerfile
DOCKER_CONTEXT?=.

# Docker image tags to build. By default we build `latest` tag and git short hash.
# `latest` can be overriden in node's Makefile.
DOCKER_IMAGE_TAG?=latest
DOCKER_IMAGE_TAGS:=$(DOCKER_IMAGE_TAG) $(GIT_SHORT_HASH)

# Extend docker build by providing SSH key for work with private resources.
DOCKER_SSH_KEY_FILE?=$(HOME)/.ssh/id_rsa

.PHONY: docker-build
docker-build:
	#### Node( '$(NODE)' ).Call( '$@' )
	@$(call COMMON_SHELL_VAR_DEFINED,DOCKER_REPOSITORY)
	@$(call COMMON_SHELL_VAR_DEFINED,DOCKER_IMAGE_TAGS)
	$(DOCKER) build \
		--no-cache \
		-f $(DOCKERFILE) \
		--build-arg SSH_PRIVATE_KEY="$$(cat $(DOCKER_SSH_KEY_FILE))" \
		$(foreach arg,$(DOCKER_BUILD_ARGS),--build-arg $(arg)) \
		$(foreach tag,$(DOCKER_IMAGE_TAGS),-t $(DOCKER_REPOSITORY):$(tag)) \
		$(DOCKER_CONTEXT)

.PHONY: docker-push
docker-push:
	#### Node( '$(NODE)' ).Call( '$@' )
	@$(call COMMON_SHELL_VAR_DEFINED,DOCKER_REPOSITORY)
	$(DOCKER) push $(DOCKER_REPOSITORY)
