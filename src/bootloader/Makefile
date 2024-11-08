# Directories
BIN=$(PWD)/bin
SRC=$(PWD)/src
MISC=$(PWD)/misc

# Vars
ASM=nasm
ASM_FLAGS=-f elf64

CC=x86_64-elf-gcc
CC_FLAGS=-m64 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mcmodel=kernel -mno-red-zone -mgeneral-regs-only -std=c11

LD=x86_64-elf-ld
LD_FLAGS=-m elf_x86_64 -T # -T has to always be the last flag


OBJ=x86_64-elf-objcopy
OBJ_FLAGS=-O binary

all: boot_stage_2 boot_stage_1
	${shell cat $(BIN)/stage1.bin $(BIN)/stage2.bin > $(BIN)/_bootloader.bin}
	@$(eval padding=$(call calculate_padding,$(BIN)/_bootloader.bin))
	$(info padding = $(padding))
	${shell dd if=/dev/zero of=$(BIN)/_padding.bin bs=1 count=$(padding)}
	${shell cat $(BIN)/_bootloader.bin $(BIN)/_padding.bin > $(BIN)/bootloader.bin}


boot_stage_2: boot_64 boot_32 boot_16
# Join all .S files that were assembled into .elf files
	${shell $(LD) $(LD_FLAGS) $(MISC)/linker/bootloader.ld $(BIN)/stage2_16.elf $(BIN)/stage2_32.elf $(BIN)/stage2_64.elf -o $(BIN)/stage2.o}
	${shell $(OBJ) $(OBJ_FLAGS) $(BIN)/stage2.o $(BIN)/stage2.bin}
	@$(eval BOOT_S2_SECTORS=$(strip $(call get_sectors, $(BIN)/stage2.bin)))


boot_64:
# Stage 2 Bootloader (64 bit)
	$(ASM) $(ASM_FLAGS) stage2_64.S -o $(BIN)/stage2_64.elf
# Stage 2 Bootloader load_kernel


boot_32:
# Stage 2 Bootloader (32 bit)
	$(ASM) $(ASM_FLAGS) stage2_32.S -o $(BIN)/stage2_32.elf

boot_16:
# Stage 2 Bootloader (16 bit)
	$(ASM) $(ASM_FLAGS) stage2_16.S -o $(BIN)/stage2_16.elf


boot_stage_1:
	@$(eval KERNEL_SECTORS=$(strip $(call get_sectors, $(BIN)/kernel.bin)))
	$(info KERNEL_SECTORS = $(KERNEL_SECTORS))

	@$(eval RESERVED_SECTORS=$(shell expr $(KERNEL_SECTORS) + $(BOOT_S2_SECTORS) + 1))
	$(info RESERVED_SECTORS = $(RESERVED_SECTORS))

# Stage 1 Bootloader
	$(ASM) -f bin stage1.S -DRESERVED_SECTORS=$(RESERVED_SECTORS) -i $(HEADER_LOCATION) -o $(BIN)/stage1.bin

define get_sectors
    $(shell expr \( $$(wc -c < $(1)) + 511 \) / 512)
endef

define calculate_padding
    $(shell expr \( 512 - $$(expr $$(wc -c < $(1)) % 512) \) % 512)
endef
