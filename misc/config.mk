# Common configuration file (config.mk)
PROJECT=$(PWD)

# Directories
MISC=$(PROJECT)/misc
BUILD=$(PROJECT)/build

SRC_DIR=$(PROJECT)/src
BOOT_DIR=$(SRC_DIR)/bootloader
KERNEL_DIR=$(SRC_DIR)/kernel
OS_FILES=$(MISC)/osfiles

BOOT_BIN=$(BUILD)/bootloader/bin
BOOT_OBJ=$(BUILD)/bootloader/obj

KERNEL_BIN=$(BUILD)/kernel/bin
KERNEL_OBJ=$(BUILD)/kernel/obj

# Variables
ASM=nasm
ASM_FLAGS=-f elf32

CC=i386-elf-gc
CC_FLAGS=-m32 -Wall -Wextra -Werror -nostdlib -fno-builtin -ffreestanding -std=c11

LD=i386-elf-ld
LD_FLAGS=-m elf_i386

OBJ_CPY=i386-elf-objcopy
OBJ_FLAGS=-O binary
