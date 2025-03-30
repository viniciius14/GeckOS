include $(CONFIG_PATH)

BOOT_SUBDIRS=$(shell find $(BOOT_DIR) -mindepth 1 -type d)
export BOOT_INCLUDES=$(foreach dir, $(BOOT_SUBDIRS), -i $(dir))

export BIN=$(BUILD_DIR)/bootloader/bin
export OBJ=$(BUILD_DIR)/bootloader/obj


bootloader: echo build boot_directories


echo:
	@echo "\nBootloader\n"


build:
	mkdir -p $(BOOT_BIN)
	mkdir -p $(BOOT_OBJ)


# Rule to iterate through each subdirectory and call its Makefile (with exception for the current one)
boot_directories:
	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)


.PHONY: bootloader
