include $(CONFIG_PATH)

BIN=$(BUILD)/kernel/bin
OBJ=$(BUILD)/kernel/obj

all: dirs boot_directories

dirs:
	mkdir -p $(BUILD)/kernel/bin
	mkdir -p $(BUILD)/kernel/obj

# Rule to iterate through each subdirectory and call its Makefile (with exception for the current one)
boot_directories:
	@echo "\nIn kernel Makefile\n"
	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)


.PHONY: all