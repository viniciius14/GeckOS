include $(CONFIG_PATH)

SRC_FILES := $(wildcard *.S)
OBJ_FILES := $(patsubst %.S, $(OBJ)/%.o, $(SRC_FILES))

default: echo link extract


echo:
	@echo "\nStage 2 Bootloader\n"


link: $(OBJ_FILES)
	$(LD) $(LD_FLAGS) -T stage2.ld $(OBJ_FILES) -o $(OBJ)/stage2.elf


extract: link
	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ)/stage2.elf $(BIN)/stage2.bin


$(OBJ)/%.o: %.S
	$(ASM) $(ASM_FLAGS) -D$(FS) -D$(BITS) $(BOOT_INCLUDES) $< -o $@


.PHONY: default
