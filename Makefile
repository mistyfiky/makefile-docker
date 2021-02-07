#!/usr/bin/make -f

ROOT_PATH=${PWD}
DOTENV_PATH=${ROOT_PATH}/.env

include ${DOTENV_PATH}
export

.DEFAULT_GOAL=all
SHELL=/bin/bash
.SHELLFLAGS=-ec
.POSIX:

.PHONY: all
all: docker-all ## run all targets

.PHONY: clean
clean: docker-clean ## clean all artifacts

.PHONY: %-clean
%-clean:
	@echo "make: Nothing to be done for '$(@)'."

.PHONY: help
help: ## show this help
	@grep -E -h '\s##\s' $(MAKEFILE_LIST) | awk -F':.*?## ' '{printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

# docker

DOCKER_CONFIG_PATH=${ROOT_PATH}/.docker
DOCKER_CONFIG_AUTH_PATH=${DOCKER_CONFIG_PATH}/config.json
DOCKER_TAG_CURRENT_PATH=${DOCKER_CONFIG_PATH}/current-tag
DOCKER_TAG_CURRENT=$(file <${DOCKER_TAG_CURRENT_PATH})
DOCKER_IMAGE_TAG_CURRENT=${DOCKER_IMAGE}:${DOCKER_TAG_CURRENT}
DOCKER_IMAGE_TAG_LATEST=${DOCKER_IMAGE}:latest
DOCKER_CONTAINER_NAME=app
DOCKER_OPTS=--config ${DOCKER_CONFIG_PATH}
DOCKER=docker ${DOCKER_OPTS}
DOCKER_LOGIN_OPTS=--username ${DCR_USERNAME} --password ${DCR_PASSWORD}
DOCKER_BUILD_OPTS=--progress plain
DOCKER_LOGS_OPTS=--follow
DOCKER_PULL_OPTS=
DOCKER_PUSH_OPTS=
DOCKER_RUN_OPTS=-itd --rm --name ${DOCKER_CONTAINER_NAME} -p 8080:8080
DOCKER_EXEC_OPTS=-it
DOCKER_EXEC_SHELL=sh
DOCKER_STOP_OPTS=-t 10

${DOCKER_CONFIG_AUTH_PATH}: ${DOTENV_PATH}
	${DOCKER} login ${DOCKER_LOGIN_OPTS} ${DCR_URL}

${DOCKER_TAG_CURRENT_PATH}:
	$(file >${DOCKER_TAG_CURRENT_PATH},$(shell git rev-parse --short=8 HEAD)-$(shell date +'%s'))
	@echo DOCKER_TAG_CURRENT=${DOCKER_TAG_CURRENT}
.PHONY: docker-current-tag
docker-current-tag: ${DOCKER_TAG_CURRENT_PATH}

docker-%-current: DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG_CURRENT}
docker-%-latest: DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG_LATEST}

.PHONY: docker-all docker-all-latest-pull docker-all-latest-build docker-all-current-build
docker-all: docker-all-latest-pull ## alias for docker-all-latest-pull
docker-all-current-build: docker-build-current docker-run-current ## build and run current docker image
docker-all-latest-build: docker-build-latest docker-run-latest ## build and run latest docker image
docker-all-latest-pull: docker-pull-latest docker-run-latest ## pull and run latest docker image

.PHONY: docker-build docker-build-current docker-build-latest
docker-build:
	${DOCKER} build ${DOCKER_BUILD_OPTS} -t ${DOCKER_IMAGE_TAG} .
docker-build-current: docker-current-tag docker-build ## build current docker image
docker-build-latest: docker-build ## build latest docker image

.PHONY: docker-clean
docker-clean: docker-stop ## clean docker artifacts
	rm -f ${DOCKER_CONFIG_AUTH_PATH} ${DOCKER_TAG_CURRENT_PATH}

.PHONY: docker-login
docker-login: ${DOCKER_CONFIG_AUTH_PATH} ## login into docker container registry

.PHONY: docker-logs
docker-logs: ## get logs from docker container
	${DOCKER} logs ${DOCKER_LOGS_OPTS} ${DOCKER_CONTAINER_NAME}

.PHONY: docker-pull docker-pull-current docker-pull-latest
docker-pull: docker-login
	${DOCKER} pull ${DOCKER_PULL_OPTS} ${DOCKER_IMAGE_TAG}
docker-pull-current: docker-current-tag docker-pull ## pull current docker image
docker-pull-latest: docker-pull ## pull latest docker image

.PHONY: docker-push docker-push-current docker-push-latest
docker-push: docker-login
	${DOCKER} push ${DOCKER_PUSH_OPTS} ${DOCKER_IMAGE_TAG}
docker-push-current: docker-current-tag docker-push ## push current docker image
docker-push-latest: docker-push ## push latest docker image

.PHONY: docker-run docker-run-current docker-run-latest
docker-run:
	${DOCKER} run ${DOCKER_RUN_OPTS} ${DOCKER_IMAGE_TAG}
docker-run-current: docker-current-tag docker-run ## run current docker image
docker-run-latest: docker-run ## run latest docker image

.PHONY: docker-shell
docker-shell: ## execute shell inside docker container
	${DOCKER} exec ${DOCKER_EXEC_OPTS} ${DOCKER_CONTAINER_NAME} ${DOCKER_EXEC_SHELL}

.PHONY: docker-stop
docker-stop: ## stop docker container
	-${DOCKER} stop ${DOCKER_STOP_OPTS} ${DOCKER_CONTAINER_NAME}

