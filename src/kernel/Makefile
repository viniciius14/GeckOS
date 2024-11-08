# CC=x86_64-elf-gcc
# CC_FLAGS=-m64 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -mcmodel=kernel -mno-red-zone -mgeneral-regs-only -std=c11

# LD=x86_64-elf-ld
# LD_FLAGS=-m elf_x86_64 -T # -T has to always be the last flag

# OBJ=x86_64-elf-objcopy
# OBJ_FLAGS=-O binary


.PHONY: all

all:
	dd if=/dev/zero of=$(PWD)/bin/kernel.bin bs=512 count=2