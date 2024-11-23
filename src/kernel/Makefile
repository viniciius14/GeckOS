# Directories
BIN=$(PWD)/bin
MISC=$(PWD)/misc
KERNEL_DIR=$(PWD)/src/kernel
INC_DIRS=${shell find $(PWD)/include -type d}

# Vars
ASM=nasm
ASM_FLAGS=-f bin

CC=x86_64-elf-gcc
CC_FLAGS=-m64 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mcmodel=large -mno-red-zone -mgeneral-regs-only -std=c11

LD=x86_64-elf-ld
LD_FLAGS=-m elf_x86_64

OBJ=x86_64-elf-objcopy
OBJ_FLAGS=-O binary

KERNEL_SRC = ${shell find *.c}

.PHONY:kernel

kernel: kernel_header

	$(info CREATING KERNEL WITH THE FOLLOWING FILES:$(NEWLINE)$(KERNEL_SRC))

# $(CC) $(CC_FLAGS) $(KERNEL_SRC) $(foreach DIR, $(INC_DIRS), -I $(DIR)) -o $(BIN)/kernel.elf
	$(CC) $(CC_FLAGS) -c $(KERNEL_DIR)/kernel_main.c $(foreach DIR, $(INC_DIRS), -I $(DIR)) -o $(BIN)/kernel.elf
	$(LD) $(LD_FLAGS) $(BIN)/kernel.elf $(BIN)/drivers.a -T $(MISC)/linker/kernel.ld -o $(BIN)/kernel.o
	$(OBJ) $(OBJ_FLAGS) $(BIN)/kernel.o $(BIN)/_kernel.bin

	cat $(BIN)/kernel_header.bin $(BIN)/_kernel.bin > $(BIN)/kernel.bin


kernel_header:
	$(ASM) $(ASM_FLAGS) $(KERNEL_DIR)/kernel_header.S -o $(BIN)/kernel_header.bin



# dd if=/dev/zero of=$(PWD)/bin/kernel.bin bs=512 count=2

# $(CC) $(CC_FLAGS) $(KERNEL_SRC)/kernel_main.c $(foreach DIR, $(INC_DIRS), -I $(DIR)) -o $(BIN)/kernel_main.elf
define NEWLINE


endef