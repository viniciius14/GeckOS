include misc/config.mk

# Define the path to config.mk
export CONFIG_PATH := $(PROJECT)/misc/config.mk

# Default inputs
export FS   ?= FAT12
export BITS ?= BITS32

# Input options
SUPPORTED_FILE_SYSTEMS := FAT12 FAT16 FAT32
SUPPORTED_TARGET_BITS  := BITS32 BITS64

# Current target
TARGET = $(OUTPUT_DIR)/GeckOS_$(FS)_$(BITS).img

OBJS=$(wildcard $(OBJ_DIR)/*.o)

GeckOS: bootloader kernel #stats image


bootloader:
	(make -C GBL/ FS=$(FS) BITS=$(BITS) OUTPUT_DIR=$(BUILD_DIR))


kernel: echo dirs
	$(foreach subdir, $(shell find . -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)
# Link
	$(LD) $(LD_FLAGS) -T $(SRC_DIR)/kernel.ld $(OBJS) -o $(OBJ_DIR)/kernel.elf
# Extract
	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ)/kernel.elf $(BIN)/kernel.bin


clean:
	rm -rf $(BUILD_DIR)
	clear


echo:
	@echo "\n--- GeckOS Kernel ---\n"


dirs:
	mkdir -p $(BIN_DIR)
	mkdir -p $(OBJ_DIR)
	mkdir -p $(DEBUG_DIR)


.PHONY: GeckOS
