include $(CONFIG_PATH)

.PHONY: kernel

kernel:
	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)
