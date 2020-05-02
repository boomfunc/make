# Some common utils and functions used anywhere.

# $(COMMON_SHELL_VAR_DEFINED) is the lazy function shell pattern to check variable is set and not empty.
define COMMON_SHELL_VAR_DEFINED
	if [ -z "$($(1))" ]; then echo 'var $(1) is undefined'; exit 1; fi
endef
