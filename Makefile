#!/usr/bin/make -f

include .env
export

.DEFAULT_GOAL=all
SHELL=/bin/bash
.SHELLFLAGS=-ec
.POSIX:

.PHONY: all
all: ## Run all targets

.PHONY: %-clean
%-clean:
	@echo "make: Nothing to be done for '$(@)'."

.PHONY: clean
clean: $(patsubst Makefile.%,%-clean,$(wildcard Makefile.*)) ## Cleanup all artifacts

.PHONY: help
help: ## Show this help
	@grep -E -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

include $(wildcard Makefile.*)
