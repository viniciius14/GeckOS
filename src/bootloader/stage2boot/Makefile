include $(CONFIG_PATH)

all: stage2_boot

stage2_boot:
	@echo "\nStage 2 Bootloader\n"
# Assemble
	$(ASM) $(ASM_FLAGS) stage2_16.S $(BOOT_INCLUDES) -o $(OBJ)/boot2_16.o
	$(ASM) $(ASM_FLAGS) stage2_32.S $(BOOT_INCLUDES) -o $(OBJ)/boot2_32.o
# Link
	$(LD) $(LD_FLAGS) -T stage2.ld 	$(OBJ)/boot2_16.o $(OBJ)/boot2_32.o -o $(OBJ)/boot2.elf
# Convert
	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ)/boot2.elf         $(BIN)/boot2.bin


.PHONY: all
