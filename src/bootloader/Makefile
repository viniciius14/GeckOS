# Directories
BIN=$(PWD)/bin
BOOT_SRC=$(PWD)/src/bootloader
MISC=$(PWD)/misc

# Vars
ASM=nasm
ASM_FLAGS=-f elf64

CC=x86_64-elf-gcc
CC_FLAGS=-m64 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mcmodel=kernel -mno-red-zone -mgeneral-regs-only -std=c11

LD=x86_64-elf-ld
LD_FLAGS=-m elf_x86_64

OBJ=x86_64-elf-objcopy
OBJ_FLAGS=-O binary

BOOT_FILES=$(BIN)/stage2_16.elf $(BIN)/stage2_32.elf $(BIN)/stage2_64.elf


all: bootloader

bootloader: _bootloader
	dd if=/dev/zero of=$(BIN)/_padding.bin bs=1 count=$(strip $(PADDING))
	cat $(BIN)/_bootloader.bin $(BIN)/_padding.bin > $(BIN)/bootloader.bin

_bootloader: boot_stage_2 boot_stage_1
	cat $(BIN)/stage1.bin $(BIN)/stage2.bin > $(BIN)/_bootloader.bin

boot_stage_2: boot_64 boot_32 boot_16
	# Link all .elf files into one output .o file
	$(LD) $(LD_FLAGS) $(BOOT_FILES) -T $(MISC)/linker/bootloader.ld -o $(BIN)/stage2.o
	$(OBJ) $(OBJ_FLAGS) $(BIN)/stage2.o $(BIN)/stage2.bin

boot_64:
	# Stage 2 Bootloader (64 bit)
	$(ASM) $(ASM_FLAGS) $(BOOT_SRC)/stage2_64.S -o $(BIN)/stage2_64.elf

	# Compile extra files
	

boot_32:
	# Stage 2 Bootloader (32 bit)
	$(ASM) $(ASM_FLAGS) $(BOOT_SRC)/stage2_32.S -o $(BIN)/stage2_32.elf

boot_16:
	# Stage 2 Bootloader (16 bit)
	$(ASM) $(ASM_FLAGS) $(BOOT_SRC)/stage2_16.S -o $(BIN)/stage2_16.elf

boot_stage_1:
	# Stage 1 Bootloader
	$(ASM) -f bin $(BOOT_SRC)/stage1.S -DRESERVED_SECTORS=$(strip $(RESERVED_SECTORS)) -i $(HEADER_LOCATION) -o $(BIN)/stage1.bin


define BOOT_S2_SECTORS
	$(shell echo $$((($$(stat -c%s $(BIN)/stage2.bin) + 511) / 512)))
endef

define KERNEL_SECTORS
	$(shell echo $$((($$(stat -c%s $(BIN)/kernel.bin) + 511) / 512)))
endef

define RESERVED_SECTORS
	$(shell expr $(KERNEL_SECTORS) + $(BOOT_S2_SECTORS) + 1)
endef

define PADDING
	$(shell wc -c < $(BIN)/_bootloader.bin | awk '{print $$1 % 512 == 0 ? 0 : 512 - ($$1 % 512)}')
endef