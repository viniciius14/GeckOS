export PROJECT:=$(abspath $(dir $(lastword $(MAKEFILE_LIST))))

include $(PROJECT)/misc/config.mk

# User inputs
export FILE_SYSTEM ?=FAT12 # Only applicable for GBL
export ARCH_BITS   ?=BITS32
export BOOTLOADER  ?=GRUB

# Input options
SUPPORTED_FILE_SYSTEMS := FAT12 FAT16 FAT32
SUPPORTED_TARGET_BITS  := BITS32 BITS64
SUPPORTED_BOOTLOADERS  := GRUB # GBL LIMINE

export DEFINES = -D$(FILE_SYSTEM) -D$(ARCH_BITS) -D$(BOOTLOADER)

# Current target
ifeq ($(BOOTLOADER), GRUB)
	TARGET = $(BUILD_DIR)/GeckOS_$(ARCH_BITS).iso
else ifeq ($(BOOTLOADER), GBL)
	TARGET = $(BUILD_DIR)/GeckOS_$(FS)_$(ARCH_BITS).img
endif

ifeq ($(ARCH_BITS), BITS32)
export ASM_FORMAT :=$(ASM_FORMAT32)
export CC         :=$(CC32)
export CC_FORMAT  :=$(CC_FORMAT32)
export LD_FORMAT  :=$(LD_FORMAT32)
export EMULATOR   :=$(EMULATOR32)
else
export ASM_FORMAT :=$(ASM_FORMAT64)
export CC         :=$(CC64)
export CC_FORMAT  :=$(CC_FORMAT64)
export LD_FORMAT  :=$(LD_FORMAT64)
export EMULATOR   :=$(EMULATOR64)
endif

# @TODO change src for a $(SRC_DIR)
SOURCE_FILES = $(shell find src -name '*.c' -o -name '*.h')

.PHONY: GeckOS run format lint analyze clean

GeckOS: dirs bootloader kernel
ifeq ($(BOOTLOADER), GRUB)
# @TODO: round about way of setting this up, not good
	@mkdir $(BUILD_DIR)/iso
	@mkdir $(BUILD_DIR)/iso/boot
	@cp -r $(BOOT_DIR)/grub $(BUILD_DIR)/iso/boot/.
	@cp $(BUILD_DIR)/kernel $(BUILD_DIR)/iso/boot/.
	@grub-mkrescue -o $(TARGET) $(BUILD_DIR)/iso/
	@rm -rf $(BUILD_DIR)/iso
else ifeq ($(BOOTLOADER), GBL)
# @TODO: here do whatever GBL requires
endif


run: GeckOS
# With grub we always create a CD iso and with GBL we create a Floppy/Hard Disk
# depending on the targeted filesystem
ifeq ($(BOOTLOADER), GRUB)
	@$(MAKE) runGrub
else ifeq ($(BOOTLOADER), GBL)
	@$(MAKE) runGBL
endif

format:
	clang-format -style=file:$(MISC_DIR)/formatter/.clang-format -i $(SOURCE_FILES)

lint: compDatabase
	clang-tidy -p $(BUILD_DIR) $(SOURCE_FILES)

analyze: compDatabase
	cppcheck --project=$(BUILD_DIR)/compile_commands.json --enable=all --inconclusive --quiet $(SOURCE_FILES)

clean:
	@rm -rf $(BUILD_DIR)

############################## End of user target ##############################

runGrub:
	$(EMULATOR) -cdrom $(TARGET) $(EMUL_FLAGS)

runGBL:
ifeq ($(FS), FAT12)
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=floppy $(EMUL_FLAGS)
else ifeq ($(FS), FAT16)
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=ide $(EMUL_FLAGS)
else ifeq ($(FS), FAT32)
	$(EMULATOR) -drive file=$(TARGET),format=raw,index=0,if=ide $(EMUL_FLAGS)
endif


bootloader:
ifeq ($(BOOTLOADER), GBL)
	(make -C $(BOOT_DIR)/GBL/ FS=$(FS) BITS=$(ARCH_BITS) OUTPUT_DIR=$(BUILD_DIR))
endif


kernel:
	@echo "\n--- GeckOS Kernel ---\n"
	$(MAKE) -C $(SRC_DIR)
# $(foreach subdir, $(shell find $(SRC_DIR) -mindepth 2 -type f -name Makefile -exec dirname {} \;), $(MAKE) -C $(subdir);)
# Link the object files
	@echo "Linking $$(cd $(OBJ_DIR) && echo *.o)"
	@$(LD) $(LD_FORMAT32) -T $(SRC_DIR)/linker.ld $(OBJ_DIR)/*.o -o $(BUILD_DIR)/kernel

# Extract the binary
# 	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ_DIR)/kernel.elf $(BIN_DIR)/kernel.bin

dirs:
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(DEBUG_DIR)

compDatabase: clean dirs
	@bear --output $(BUILD_DIR)/compile_commands.json -- make
