include $(CONFIG_PATH)

KERNEL_SUBDIRS=$(shell find $(KERNEL_DIR) -mindepth 1 -type d)
export KERNEL_INCLUDES=$(foreach dir, $(KERNEL_SUBDIRS), -I $(dir))

export BIN=$(BUILD)/kernel/bin
export OBJ=$(BUILD)/kernel/obj

all: dirs kernel_directories

dirs:
	mkdir -p $(BUILD)/kernel/bin
	mkdir -p $(BUILD)/kernel/obj

# Rule to iterate through each subdirectory and call its Makefile (with exception for the current one)
kernel_directories:
	@echo "\nKernel\n"
	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)


.PHONY: all
