include $(CONFIG_PATH)

BOOT_SUBDIRS=$(shell find $(BOOT_DIR) -mindepth 1 -type d)
BOOT_INCLUDES=$(foreach dir, $(BOOT_SUBDIRS), -i $(dir))

ASM_FLAGS=-f bin

all: stage1_boot

stage1_boot:
	@echo "\nStage 1 Bootloader\n"
	$(ASM) $(ASM_FLAGS) stage1.S -DFAT_12 $(BOOT_INCLUDES) -o $(BIN)/boot_FAT12.bin
	$(ASM) $(ASM_FLAGS) stage1.S -DFAT_16 $(BOOT_INCLUDES) -o $(BIN)/boot_FAT16.bin
	$(ASM) $(ASM_FLAGS) stage1.S -DFAT_32 $(BOOT_INCLUDES) -o $(BIN)/boot_FAT32.bin

.PHONY: all
