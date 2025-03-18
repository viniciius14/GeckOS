include $(CONFIG_PATH)


all: stage2_boot


stage2_boot:
	@echo "\nStage 2 Bootloader\n"
# Assemble
	$(ASM) $(ASM_FLAGS) stage2_16.S $(BOOT_INCLUDES) -DFAT_12 -o $(OBJ)/boot2_16.o
	$(ASM) $(ASM_FLAGS) stage2_32.S $(BOOT_INCLUDES) -DFAT_12 -o $(OBJ)/boot2_32.o
# Compile
# $(CC) $(CC_FLAGS) -c fdc.c -o $(OBJ)/test.o
# Link
# $(LD) $(LD_FLAGS) -T stage2.ld 	$(OBJ)/boot2_16.o $(OBJ)/boot2_32.o $(OBJ)/test.o -o $(OBJ)/boot2.elf
	$(LD) $(LD_FLAGS) -T stage2.ld 	$(OBJ)/boot2_16.o $(OBJ)/boot2_32.o -o $(OBJ)/boot2.elf
# Extract
	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ)/boot2.elf         $(BIN)/boot2.bin


.PHONY: all



# include $(CONFIG_PATH)

# # Find all .S and .c files in the current directory
# S_SOURCES = $(wildcard *.S)
# C_SOURCES = $(wildcard *.c)

# OBJS = $(S_SOURCES:.S=.o) $(C_SOURCES:.c=.o)


# # Default target
# all: echo stage2_boot


# echo:
# 	@echo "\nStage 2 Bootloader\n"


# stage2_boot: $(OBJS)
# # Link
# 	$(LD) $(LD_FLAGS) -T stage2.ld $(addprefix $(OBJ)/, $(OBJS)) -o $(OBJ)/boot2.elf
# # Extract
# 	$(OBJ_CPY) $(OBJ_FLAGS) $(OBJ)/boot2.elf $(BIN)/boot2.bin


# %.o: %.S
# 	$(ASM) $(ASM_FLAGS) $< $(BOOT_INCLUDES) -o $(OBJ)/$@


# %.o: %.c
# 	$(CC) $(CC_FLAGS) -c $< -o $(OBJ)/$@

# .PHONY: all
