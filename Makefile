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
TARGET = $(BUILD_DIR)/GeckOS_$(FS)_$(BITS).img

GeckOS: bootloader kernel stats image


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


run: GeckOS
ifeq ($(FS), FAT12)
	$(MAKE) run_floppy
else ifeq ($(FS), FAT16)
	$(MAKE) run_hard_disk
else ifeq ($(FS), FAT32)
	$(MAKE) run_hard_disk
endif


run_floppy:
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=floppy $(EMUL_FLAGS)


run_hard_disk:
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=ide $(EMUL_FLAGS)


stats:
	@echo "--- TARGET -> $(TARGET) ---" >> $(STATS)
	$(call obj_count)
	$(call bin_size_stat, $(BIN_DIR)/kernel.bin)
	@echo "\n" >> $(STATS)


image:
	mcopy -i $(TARGET) $(BIN_DIR)/kernel.bin ::


clean:
	rm -rf $(BUILD_DIR)
	(make -C GBL/ clean)
	clear


dirs:
	mkdir -p $(BIN_DIR)
	mkdir -p $(OBJ_DIR)
	mkdir -p $(DEBUG_DIR)


define bin_size_stat
	@wc -c $1 | awk '{ if ($$2 != "total") { n=split($$2,a,"/"); printf "%s - %s bytes\n", a[n], $$1 } }' >> $(STATS)
endef


define obj_count
	@echo "Object unit count -> $$(ls $(OBJ_DIR)/*.o | wc -l)" >> $(STATS)
endef

.PHONY: GeckOS
