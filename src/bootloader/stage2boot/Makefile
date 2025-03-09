include $(CONFIG_PATH)

BOOT_SUBDIRS=$(shell find $(BOOT_DIR) -mindepth 1 -type d)
BOOT_INCLUDES=$(foreach dir, $(BOOT_SUBDIRS), -i $(dir))

ASM_FLAGS=-f bin

all: stage2_boot


stage2_boot:
	@echo "\nStage 2 Bootloader\n"
	$(ASM) $(ASM_FLAGS)	stage2.S $(BOOT_INCLUDES) -o $(BIN)/boot2.bin


.PHONY: all