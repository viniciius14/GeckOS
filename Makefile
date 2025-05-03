include misc/config.mk

# Define the path to config.mk
export CONFIG_PATH := $(PROJECT)/misc/config.mk

# Default inputs
export FS ?= FAT12
export BITS ?= BITS32

# Input options
SUPPORTED_FILE_SYSTEMS := FAT12 FAT16 FAT32
SUPPORTED_TARGET_BITS  := BITS32 BITS64

# Current target
TARGET = $(OUTPUT_DIR)/GeckOS_$(FS)_$(BITS).img

GeckOS: bootloader kernel #stats image


bootloader: dirs
	(make -C GBL/ FS=$(FS) BITS=$(BITS) OUTPUT_DIR=$(BUILD_DIR))


kernel:
	@echo "\n--- GeckOS Kernel ---\n"
	$(MAKE) -C $(SRC_DIR)
# $(foreach subdir, $(shell find $(SRC_DIR) -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)
# Link the object files
	$(LD) $(LD_FLAGS) -T $(SRC_DIR)/kernel.ld $(OBJ_DIR)/*.o -o $(OBJ_DIR)/kernel.elf
# Extract the binary
	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ_DIR)/kernel.elf $(BIN_DIR)/kernel.bin


clean:
	rm -rf $(BUILD_DIR)
	clear


dirs:
	mkdir -p $(BIN_DIR)
	mkdir -p $(OBJ_DIR)
	mkdir -p $(DEBUG_DIR)


.PHONY: GeckOS
