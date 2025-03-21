include $(CONFIG_PATH)

SRC_FILES := $(wildcard *.S)
OBJ_FILES := $(patsubst %.S, $(BIN)/%_$(FS).bin, $(SRC_FILES))

ASM_FLAGS=-f bin

default: echo assemble


echo:
	@echo "\nStage 1 Bootloader\n"


assemble: $(OBJ_FILES)


$(BIN)/%_$(FS).bin: %.S
	$(ASM) $(ASM_FLAGS) -D$(FS) -D$(BITS) $(BOOT_INCLUDES) $< -o $@


.PHONY: default
