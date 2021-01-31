# Modular Makefile template

Template repository with modular Makefile system.

## Setup

```shell
export GHCR_URL='https://ghcr.io'
export GHCR_USR=''
export GHCR_PAT=''
export GHCR_IMG='ghcr.io/mistyfiky/modular-makefile'
DCR_URL=${GHCR_URL} \
DCR_USERNAME=${GHCR_USR} \
DCR_PASSWORD=${GHCR_PAT} \
DOCKER_IMAGE=${GHCR_IMG} \
make
```

## Links

[Creating a personal access token - GitHub Docs](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

[How to create a self-documenting Makefile | victoria.dev](https://victoria.dev/blog/how-to-create-a-self-documenting-makefile/)
