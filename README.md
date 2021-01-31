# Modular Makefile template

Template repository with modular Makefile system.

## Setup

```shell
export GHCR_URL='https://ghcr.io'
export GHCR_USER=''
export GHCR_PERSONAL_ACCESS_TOKEN=''
export GHCR_IMAGE_NAME=''
DCR_URL=${GHCR_URL} \
DCR_USERNAME=${GHCR_USER} \
DCR_PASSWORD=${GHCR_PERSONAL_ACCESS_TOKEN} \
DOCKER_IMAGE=${GHCR_IMAGE_NAME} \
make
```

## Links

[Creating a personal access token - GitHub Docs](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

[How to create a self-documenting Makefile | victoria.dev](https://victoria.dev/blog/how-to-create-a-self-documenting-makefile/)
