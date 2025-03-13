include $(CONFIG_PATH)

# Include all directories except stage1boot
BOOT_SUBDIRS=$(shell find $(BOOT_DIR) -mindepth 1 -type d ! -name "stage1boot")
BOOT_INCLUDES=$(foreach dir, $(BOOT_SUBDIRS), -i $(dir))

ASM_FLAGS=-f bin

all: stage2_boot

stage2_boot:
	@echo "\nStage 2 Bootloader\n"
	$(ASM) $(ASM_FLAGS) stage2_16.S $(BOOT_INCLUDES) -o $(BIN)/boot2_16.bin
	$(ASM) $(ASM_FLAGS) stage2_32.S $(BOOT_INCLUDES) -o $(BIN)/boot2_32.bin
# $(ASM) $(ASM_FLAGS) stage2_64.S $(BOOT_INCLUDES) -o $(BIN)/boot2_64.bin
# mv $(BIN)/boot2_16.bin $(BIN)/boot2.bin
	cat $(BIN)/boot2_16.bin $(BIN)/boot2_32.bin > $(BIN)/boot2.bin
# cat $(BIN)/boot2_16.bin $(BIN)/boot2_32.bin $(BIN)/boot2_64.bin > $(BIN)/boot2.bin

.PHONY: all
