#!/usr/bin/make -f

.DEFAULT_GOAL=help
SHELL=/bin/bash
.SHELLFLAGS=-ec
.POSIX:

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: %-clean
%-clean:
	@echo "make: Nothing to be done for '$(@)'."

.PHONY: clean
clean: $(patsubst Makefile.%,%-clean,$(wildcard Makefile.*)) ## Cleanup the Directory

include $(wildcard Makefile.*)
