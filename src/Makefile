include $(CONFIG_PATH)

.PHONY: all

all:
	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)
