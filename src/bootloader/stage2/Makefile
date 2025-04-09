include $(CONFIG_PATH)

SRCS := $(wildcard *.S)
OBJS := $(patsubst %.S, $(OBJ)/%.o, $(SRCS))

default: echo extract


echo:
	@echo "\nStage 2 Bootloader\n"


link: $(OBJS)
	$(LD) $(LD_FLAGS) -T stage2.ld $(OBJS) -o $(OBJ)/stage2.elf


extract: link
	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ)/stage2.elf $(BIN)/stage2.bin


$(OBJ)/%.o: %.S
	$(ASM) $(ASM_FORMAT) $(ASM_FLAGS) -D$(FS) -D$(BITS) $(BOOT_INCLUDES) $< -o $@


.PHONY: default
