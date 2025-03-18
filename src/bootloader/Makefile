include $(CONFIG_PATH)

BOOT_SUBDIRS=$(shell find $(BOOT_DIR) -mindepth 1 -type d)
export BOOT_INCLUDES=$(foreach dir, $(BOOT_SUBDIRS), -i $(dir))

export BIN=$(BUILD)/bootloader/bin
export OBJ=$(BUILD)/bootloader/obj


all: build boot_directories


build:
	mkdir -p $(BUILD)/bootloader/bin
	mkdir -p $(BUILD)/bootloader/obj


# Rule to iterate through each subdirectory and call its Makefile (with exception for the current one)
boot_directories:
	@echo "\nIn bootloader Makefile\n"
	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)


.PHONY: all
