include $(CONFIG_PATH)

KERNEL_SUBDIRS=$(shell find $(KERNEL_DIR) -mindepth 1 -type d)
export KERNEL_INCLUDES=$(foreach dir, $(KERNEL_SUBDIRS), -I $(dir))

export BIN=$(BUILD_DIR)/kernel/bin
export OBJ=$(BUILD_DIR)/kernel/obj

kernel: echo dirs kernel_directories


echo:
	@echo "\nKernel\n"

dirs:
	mkdir -p $(KERNEL_BIN)
	mkdir -p $(KERNEL_OBJ)
	mkdir -p $(KERNEL_LIB)

# Rule to iterate through each subdirectory and call its Makefile (with exception for the current one)
kernel_directories:
	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)


.PHONY: kernel
