include $(CONFIG_PATH)


ASM_FORMAT=-f bin

default: echo assemble


echo:
	@echo "\nStage 1 Bootloader\n"


assemble:
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) -D$(FS) -D$(BITS) $(BOOT_INCLUDES) stage1.S -o $(BIN)/stage1_$(FS).bin


.PHONY: default
